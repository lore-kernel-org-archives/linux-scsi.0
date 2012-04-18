From: Tom Rini <trini@ti.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Wed, 18 Apr 2012 08:23:11 -0700
Message-ID: <4F8EDC5F.9090600@ti.com>
References: <20120416224250.GA1983@bill-the-cat>	<CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>	<4F8CAC6F.6070907@ti.com>	<1334620782.23541.2.camel@ultramagnus.opencreations.com>	<4F8CCD0C.5060900@ti.com>	<1334633159.13899.4.camel@dwillia2-mobl>	<1334677637.3766.66.camel@dabdike>	<CABE8wwvThcO4B+qQUMBg+OMdTbF5VMZ0THD9SftSocj+oBOARw@mail.gmail.com> <CAA9_cmeY0VaRqgfjqZbFbqP8u+wvkJ8=dJUNk9kkBabAF15t1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45188 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2DRPXS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2012 11:23:18 -0400
In-Reply-To: <CAA9_cmeY0VaRqgfjqZbFbqP8u+wvkJ8=dJUNk9kkBabAF15t1w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

On 04/17/2012 10:11 PM, Dan Williams wrote:
> On Tue, Apr 17, 2012 at 10:17 AM, Dan Williams<dan.j.williams@intel.com>  wrote:
>> On Tue, Apr 17, 2012 at 8:47 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com>  wrote:
>>> On Mon, 2012-04-16 at 20:25 -0700, Dan Williams wrote:
>>>> Agh, sorry, I rushed that one.  The phy array is initialized later, here
>>>> is another run at it:
>>>
>>> Are we sure it's initialised correctly in all the other SAS drivers that
>>> use (well, one other: aic94xx)?
>>
>> Looks like we need:
>>
>> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c
>> b/drivers/scsi/aic94xx/aic94xx_init.c
>> index ff80552..830f438 100644
>> --- a/drivers/scsi/aic94xx/aic94xx_init.c
>> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
>> @@ -250,6 +250,7 @@ static int __devinit asd_common_setup(struct
>> asd_ha_struct *asd_ha)
>>                         SAS_LINK_RATE_1_5_GBPS;
>>                 asd_ha->hw_prof.phy_desc[i].min_sata_lrate =
>>                         SAS_LINK_RATE_1_5_GBPS;
>> +               asd_ha->phys[i].sas_phy.id = i;
>>         }
>>
>>         return 0;
>>
>>> Given the oops issue, perhaps revert this for now and get a working
>>> patch in for the next merge window?
>>
>> I have no strong feelings either way, but aic94xx and mvsas
>> maintainers have been hard to reach and I'm not encouraged more time
>> will yield a different result versus just moving ahead with these
>> fixes.
>>
>> That said we still have Tom's discovery regression which is a separate issue.
>
> I take it back.
>
> I overlooked what Tom said at the very beginning.  Everything is fixed
> by the revert, and I now see why my later "fix" made it worse.  The
> fix overlooked that mvsas is indeed initializing the phy ids, but in
> the "multi-chip" case it does a rather annoying duplication of phy ids
> in the array passed to libsas.  So, for example, chip0 has phy0-3 at
> ha phy index 0-3 and chip1 has its phy0-3 at ha phy index 4-7.  So the
> "fix" was breaking mvsas's ability to lookup phys by id and the
> original commit is tripped up by mvsas's scheme of putting non-unique
> ids in the sas_ha_struct.
>
> Question for a later day, but why isn't mvsas creating a scsi_host per
> chip??  That can only help performance and is more in line with
> reality.

Performance isn't in-line with what I would expect (in playing with 
fio), so if you want to whip something up, or point me some changesets / 
other drivers I can take a stab here.  Thanks!

-- 
Tom
