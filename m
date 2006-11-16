From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 0/8] target mode support
Date: Thu, 16 Nov 2006 12:18:48 -0500
Message-ID: <455C9D78.7020400@emulex.com>
References: <20061116192358C.fujita.tomonori@lab.ntt.co.jp> <455C76D1.9050501@emulex.com> <455C9299.5010202@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58314 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1031113AbWKPRTV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 12:19:21 -0500
In-Reply-To: <455C9299.5010202@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James Bottomley <James.Bottomley@SteelEye.com>

Ok.  My assumption is that it is preferred to be a single mode, but that
dual mode should be supported.  Please note that dual mode may impact some
of the feature set in the emulated target - and it'll be a trick to identify
that.

Hmm... what this leads me to is - there is a difference between the
pure SCSI behavior (performing a SCSI Read command), and the transport-level
SCSI behavior (Mode Pages; FCP: Conf, Recovery; iSCSI CmdSN/StatSN progression,
SNACK, RSP retransmission, etc). Although, these will be very tightly
integrated.  How does this code account for this ?  Are there transport-level
libraries in-between the LLDD and the SCSI Target ? Is it reflected in the
LLDD to SCSI Target messaging ?

-- james


Mike Christie wrote:
> James Smart wrote:
>> One question....
>>
>> Does this assume that an hba is both initiator and target ?  target only ?
>> Do we have any issues if a scsi_host is a target only ?
>>
> 
> I do not think that is fully worked out yet. The only target that is
> done is the vscsi one which is a little different from something like
> lpfc or qla*. I think some developers like Qlogic would prefer the
> driver and card is only in one mode or the other to simplify things.
> However, I think Tomo and users would like to be able to use a
> card/driver in both modes at the same time.
> 
