From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 01/07] lpfc 8.3.29: BSG and User interface fixes
Date: Thu, 19 Jan 2012 12:33:37 -0500
Message-ID: <4F1853F1.4020909@emulex.com>
References: <1326921829.32733.10.camel@ogier> <4F174603.8060104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:42872 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932440Ab2ASRd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 12:33:59 -0500
In-Reply-To: <4F174603.8060104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Yes.

I'm open to either the scsi_lib helper function, so we have consistent 
naming.  However, the real answer is to fix bsg to take out references on the 
object that registers with bsg - so that driver unload is gated on proper 
unregistration, and no outstanding bsg requests.  Who knows bsg well enough to 
do this ?

-- james s


On 1/18/2012 5:21 PM, Mike Christie wrote:
> On 01/18/2012 03:23 PM, James Smart wrote:
>> >  - Create character device to take a reference on the driver (126082)
>> >
> Is this so the driver cannot get unloaded when doing multiple bsg/sysfs
> requests? If so having every driver create its own char device seems
> wrong. qla2xxx does this too.qla4xxx wants to do it.  Every driver has
> the problem.
>
> If we do this can we at least have a scsi lib helper function that can
> enforce a consistent naming policy for the char devs so userspace apps
> do not have to have some crazy look up table for every driver.
>
> Or, is there a better way to support this? Maybe a common sysfs attr on
> the host or a bsg request? Something common that works for all drivers
> so we do not have to go around to every driver and add char device to them?
>
>
>
