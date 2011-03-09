From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/2] hpsa: export resettable_on_kexec host attribute
Date: Wed, 09 Mar 2011 16:33:54 +0100
Message-ID: <4D779DE2.5030908@redhat.com>
References: <20110308230749.22291.56200.stgit@beardog.cce.hp.com> <20110308231003.22291.20417.stgit@beardog.cce.hp.com> <4D777249.10400@redhat.com> <20110309151457.GI12760@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1CIPfL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2011 10:35:11 -0500
In-Reply-To: <20110309151457.GI12760@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

On 03/09/2011 04:14 PM, scameron@beardog.cce.hp.com wrote:
> On Wed, Mar 09, 2011 at 01:27:53PM +0100, Tomas Henzl wrote:
>   
>> On 03/09/2011 12:10 AM, Stephen M. Cameron wrote:
>>     
>>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>>
>>> This attribute, requested by Redhat, allows kexec-tools to know
>>> whether the controller can honor the reset_devices kernel parameter
>>>       
>>     
> [...]
>
>   
>> and actually reset the controller.  For kdump to work properly it
>> Hi Stephen,
>>
>> thanks for posting this.
>> Some of the devices are served by the cciss driver by default - I guess
>> a very similar patch for cciss is needed too.
>> Shouldn't be the 0x409C0E11 and 0x409D0E11 (640x boards) also added to the list?
>> (And the 'unknown' devices.)
>>     
> There's a bit of a fine point here regarding the unknown devices.
>
> If hpsa_allow_any=1 module parameter is set, then the unknown device
> is considered to be resettable (as it's unknown, it's obviously not
> on the list of known unresettable controllers).  If hpsa_allow_any
> is not set, then the unknown devices are not reset -- and the driver
> doesn't even try to do anything with them.  
>
> So, the patch is consistent with this, in that if hpsa_allow_any is
> not set, then there won't be any corresponding sysfs entries at all
> for those devices because those devices won't be service by hpsa
> at all.  And if hpsa_allow_any is set, then those devices will be
> marked as resettable, and the reset code will attempt to reset them.
>
> I think we've got all the unresettable devices listed (when I add the 6400
> boards to the list of course) and I think we're going to try pretty hard to
> make sure new boards are resettable, so, that's probably ok, right?
>   
> Or, do you want to be extra safe, and say that new, unknown boards are assumed
> to be non-resettable?  (Since new boards generally mean driver changes to make
> sure the driver knows those boards, that's not such a big deal -- except for
> people who want to continue to use old OSes on new hardware, which, there seem
> to be quite a few of those people.)
>   
My comment has targeted the new unknown boards, to resolve this it would be easier
to have a list of resettable controllers. (complement to what it is now).

Fact is, that I forgot that a hpsa_allow_any option has to be set before you can
use an 'unknown' controller and combined with your promise 
> we're going to try pretty hard to make sure new boards are resettable
I'm fine with the original approach.

-- tomash


> I think my preference would be to assume that unknown boards are resettable
> if hpsa_allow_any=1, and assume unresettable otherwise (and for purposes of
> sysfs attributes, this is what the patch already does.)
>
> -- steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

