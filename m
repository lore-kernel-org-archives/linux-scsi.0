From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] mpt3sas: Force request partial completion alignment
Date: Wed, 1 Feb 2017 09:48:46 -0200
Message-ID: <9bd6fc89-0017-0a4d-7e6b-b0e779ddd9d6@linux.vnet.ibm.com>
References: <1485455821-9176-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
 <yq1bmumzirw.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43161 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751192AbdBALtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2017 06:49:04 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v11Bme1Y094255
        for <linux-scsi@vger.kernel.org>; Wed, 1 Feb 2017 06:49:03 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28bbrayttw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 01 Feb 2017 06:49:02 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Wed, 1 Feb 2017 09:49:00 -0200
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id 83DFC352006E
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2017 06:48:25 -0500 (EST)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v11BmwDM5087386
        for <linux-scsi@vger.kernel.org>; Wed, 1 Feb 2017 09:48:58 -0200
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v11Bmw6U020106
        for <linux-scsi@vger.kernel.org>; Wed, 1 Feb 2017 09:48:59 -0200
In-Reply-To: <yq1bmumzirw.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, brking@linux.vnet.ibm.com, mauricfo@linux.vnet.ibm.com, linuxram@us.ibm.com

On 01/02/2017 01:34, Martin K. Petersen wrote:
>>>>>> "Guilherme" == Guilherme G Piccoli <gpiccoli@linux.vnet.ibm.com> writes:
> 
> Guilherme> The firmware or device, possibly under a heavy I/O load, can
> Guilherme> return on a partial unaligned boundary. Scsi-ml expects these
> Guilherme> requests to be completed on an alignment boundary. Scsi-ml
> Guilherme> blindly requeues the I/O without checking the alignment
> Guilherme> boundary of the I/O request for the remaining bytes. This
> Guilherme> leads to errors, since devices cannot perform non-aligned
> Guilherme> read/write operations.
> 
> Guilherme> This patch fixes the issue in the driver. It aligns unaligned
> Guilherme> completions of FS requests, by truncating them to the nearest
> Guilherme> alignment boundary.
> 
> Applied to 4.10/scsi-fixes.
> 

Thanks Martin!
