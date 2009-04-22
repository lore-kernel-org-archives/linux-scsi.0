From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] RFC: have dm-mpath use already attached
	scsi_dh
Date: Wed, 22 Apr 2009 08:52:55 -0500
Message-ID: <49EF2137.80708@cs.wisc.edu>
References: <1240374806-6043-1-git-send-email-michaelc@cs.wisc.edu>
	<49EEE071.9060902@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49EEE071.9060902@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Levy_Jerome@emc.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Hi Mike,
> 
> michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> If you have a mixed environment of clarriions, where some
>> support ALAU and some support PNR, what do you put in
>> your multipath.conf? With this patch you do not have to worry about
>> it. If those modules are loaded before dm-mpath, then they
>> will have attached to the correct devices based on inquiry, alua commands
>> and parsing of data buffers (for example in scsi_dh_emc's alua check).
>> There is no need for the user to set that info in the multipath.conf.
>> And in general since all scsi_dh_modules will attach to the devices
>> they work for, we do not need to have users specific this.
>>
> No. The problem here is the hardware table from scsi_dh is compiled
> in and cannot be changed from userland. The multipath.conf OTOH
> is purely user-defined and, what's more, the user might have a valid
> reason for modifying it.
> (EG EMC Clariion can well be run in PNR mode even though ALUA is
> active, or the user might want to try ALUA on any as-of-yet unknown
> devices)

Ah. I misread the code and misunderstood the compat mode. I thought 
scsi_dh_emc was failing the attach when ALUA support was detected.

> 
> So _not_ allowing multipath to override the device handler setting
> will just add to the confusion and makes error tracking even more
> difficult.
> 
> So I would prefer the attached patch, it even save to touch
> device handler code at all.
> 

Thanks. I think this will work for me.

Are you going to push this for 2.6.30?
