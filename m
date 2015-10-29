From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 13/25] hpsa: simplify update scsi devices
Date: Thu, 29 Oct 2015 15:28:57 -0500
Message-ID: <31226204-CB27-4423-9151-33A8697B6B16@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220549.5323.85641.stgit@brunhilda> <998BCB19-5910-44A6-A53F-29BB78160ED9@linux.vnet.ibm.com> <56326D0F.50203@pmcs.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:54197 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490AbbJ2U3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 16:29:02 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 29 Oct 2015 14:29:01 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 15A861FF002D
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 14:17:11 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9TKRaOl3473866
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 13:27:36 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9TKSwjK029182
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 14:28:59 -0600
In-Reply-To: <56326D0F.50203@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <brace77070@gmail.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Oct 29, 2015, at 2:01 PM, Don Brace <brace77070@gmail.com> wrote:
> 
> On 10/29/2015 11:43 AM, Matthew R. Ochs wrote:
>>> On Oct 28, 2015, at 5:05 PM, Don Brace <don.brace@pmcs.com> wrote:
>>> 
>>> From: Kevin Barnett <kevin.barnett@pmcs.com>
>>> 
>>> remove repeated calculation that checks for physical
>>> or logical devices.
>>> 
>>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>>> ---
>>> drivers/scsi/hpsa.c |   23 ++++++++++++++---------
>>> drivers/scsi/hpsa.h |    1 +
>>> 2 files changed, 15 insertions(+), 9 deletions(-)
>>> 
>>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>>> index d011540..7c1a552 100644
>>> --- a/drivers/scsi/hpsa.c
>>> +++ b/drivers/scsi/hpsa.c
>>> @@ -3761,6 +3761,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>>> 	int ncurrent = 0;
>>> 	int i, n_ext_target_devs, ndevs_to_allocate;
>>> 	int raid_ctlr_position;
>>> +	bool physical_device;
>> Any particular reason for using a bool here and a u8 when you cache the value?
> Changed definition to u8 physical_device : 1; in hpsa_scsi_dev_t
> 
>> 
>>> 	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
>>> 
>>> 	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
>>> @@ -3821,16 +3822,17 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>>> 		int rc = 0;
>>> 		int phys_dev_index = i - (raid_ctlr_position == 0);
>>> 
>>> +		physical_device = i < nphysicals + (raid_ctlr_position == 0);
>>> +
>>> 		/* Figure out where the LUN ID info is coming from */
>>> 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
>>> 			i, nphysicals, nlogicals, physdev_list, logdev_list);
>>> 
>>> 		/* skip masked non-disk devices */
>>> -		if (MASKED_DEVICE(lunaddrbytes))
>>> -			if (i < nphysicals + (raid_ctlr_position == 0) &&
>>> -				(physdev_list->
>>> -				LUN[phys_dev_index].device_flags & 0x01))
>>> -				continue;
>>> +		if (physical_device &&
>>> +			MASKED_DEVICE(lunaddrbytes) &&
>>> +			(physdev_list->LUN[phys_dev_index].device_flags & 0x01))
>>> +			continue;
>> In this conditional you swapped the ordering, evaluating physical_device first, why?
> Changed it back. Better to be consistent.

With these changes I'm fine with you adding

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

