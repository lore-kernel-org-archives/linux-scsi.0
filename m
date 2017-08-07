From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: nvmf question - synchronization between target/initiator regarding
 partitions
Date: Mon, 7 Aug 2017 10:42:57 -0300
Message-ID: <82c4d1d8-ffa9-fa99-df58-05e2945eafdc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44739 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751415AbdHGNnF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 09:43:05 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v77Ddstm134732
        for <linux-scsi@vger.kernel.org>; Mon, 7 Aug 2017 09:43:04 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2c6jjp239w-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2017 09:43:04 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Mon, 7 Aug 2017 09:43:03 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
Cc: Mauricio pIO <mauricfo@linux.vnet.ibm.com>, Brian J King <bjking1@us.ibm.com>, Murali N Iyer <mniyer@us.ibm.com>, vnarasimhan@in.ibm.com, gpiccoli@linux.vnet.ibm.com

We observed that it's possible to perform partition operations in both
nvmf target and initiator block devices, like creating and deleting
partitions.

But there is no sync mechanism between target and initiator regarding
the partitions operations. After creating a partition on initiator, for
example, we don't see it on target side. We could format it like ext4 on
initiator, and still target cannot see it. It's possible to trigger a
BLKRRPART ioctl on target, which end up calling revalidate_disk() on
nvme driver and then partitions are perceived.

So, question: is this behavior expected/acceptable? Is it completely up
to userspace to deal with the synchronization between host/target?
I think answer might be yes since partitions are a higher level of
abstraction than nvmf (which is purely block device aware).

But if kernel could/should jump in, we possibly could try to issue a
revalidate_disk on target whenever this operation is performed on
initiator side (and vice-versa). I confess I couldn't find such sync
idea in NVMe over fabrics spec, though.
Also, reading NVMe spec 1.3, we do have the optional feature
"reservations", but seems it doesn't mention target (only multiple hosts).

Thanks in advance for any ideas on this subject.
Cheers,



Guilherme
