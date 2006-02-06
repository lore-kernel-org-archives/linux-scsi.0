From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
Date: Mon, 06 Feb 2006 11:54:48 -0600
Message-ID: <43E78D68.7010301@cs.wisc.edu>
References: <1138157885.11692.32.camel@max>	<1139164228.3017.14.camel@mulgrave.il.steeleye.com> <20060206113356T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33995 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932189AbWBFRy6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 12:54:58 -0500
In-Reply-To: <20060206113356T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Subject: Re: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
> Date: Sun, 05 Feb 2006 12:30:28 -0600
> 
> 
>>OK ... I think this looks good enough to fix up in tree.  I just have
>>one minor quibble, so could you fix that and I'll put it in.
>>
>>On Tue, 2006-01-24 at 20:58 -0600, Mike Christie wrote:
>>
>>>@@ -31,6 +32,7 @@ struct scsi_pointer {
>>> struct scsi_cmnd {
>>>        int     sc_magic;
>>> 
>>>+       struct Scsi_Host *shost;
>>>        struct scsi_device *device;
>>
>>This is an unnecessary addition; you can get this from device->host.
> 
> 
> Thanks a lot. I've just fixed this.
> 

We actually need ths shost pointer becuase we do not represent the LU in 
the kernel. So we go from:

scsi_host -> host's uspace request_queue (used to pass commands and 
messages from the target LLD interrup handler to our netlink 
code/userspace -> in userspace we represent the target, device/LU, and host.

Tomo did you add a virtual scsi_device somewhere?
