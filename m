From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 3/6] bfa: remove os wrapper functions and macros
Date: Wed, 20 Oct 2010 16:48:18 -0700
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CF81311C@HQ1-EXCH01.corp.brocade.com>
References: <1287447149-28678-1-git-send-email-huangj@brocade.com>
 <4CBF09DF.8000308@redhat.com> <4CBF6A38.7060502@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:59732 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053Ab0JTXsk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2010 19:48:40 -0400
In-Reply-To: <4CBF6A38.7060502@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Rob Evers <revers@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

>On 10/20/2010 10:25 AM, Rob Evers wrote:
>> Is scsi_for_each_sg() use pretty standard for mass storage drivers these
>> days?
>
>Yes, the driver should be using it.
>

We are not using the scsi_for_each_sg because currently we setup the scsi data buffers in two separate steps.
The reason of doing that is we allow one buffer being inlined in the IO request, while the remaining buffers 
in sg pages. The sg elements in the IO request and sgpg have different format per ASIC spec, we hence think
It is logically clearer to set them up in two different functions.

