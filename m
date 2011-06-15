From: Kiran Patil <kiran.patil@intel.com>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking	IRQ-safe
Date: Wed, 15 Jun 2011 10:52:35 -0700
Message-ID: <4DF8F163.6010103@intel.com>
References: <1308023045-5257-1-git-send-email-roland@kernel.org>	 <1308157596.20109.28.camel@haakon2.linux-iscsi.org>	 <BANLkTimM-=fGphT_okWuMYY1LgDk=XQzow@mail.gmail.com> <1308158714.20109.33.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43813 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1FORwg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2011 13:52:36 -0400
In-Reply-To: <1308158714.20109.33.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/15/2011 10:25 AM, Nicholas A. Bellinger wrote:
> On Wed, 2011-06-15 at 10:22 -0700, Roland Dreier wrote:
>> On Wed, Jun 15, 2011 at 10:06 AM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org>  wrote:
>>> Btw, I think the same type of conversion may need to happen for
>>> transport_lookup_tmr_lun() as well, as I believe qla_target.c can call
>>> this directly from interrupt context in certain situations.
>> Yes, I think I sent another mail about this... the reason I didn't just
>> send a patch is that transport_lookup_tmr_lun() ends with:
>>
>>          spin_lock(&se_tmr->tmr_dev->se_tmr_lock);
>>          list_add_tail(&se_tmr->tmr_list,&se_tmr->tmr_dev->dev_tmr_list);
>>          spin_unlock(&se_tmr->tmr_dev->se_tmr_lock);
>>
>> and indeed se_tmr_lock looks like it is taken with bare spin_lock()
>> in lots of places.
>>
> Actually, it's only two places:  core_tmr_release_req() and
> core_tmr_lun_reset()
>
>> Presumably se_tmr_lock is taken from process context sometimes?
>> So we would need to convert all those spin_lock()s to spin_lock_irq()
>> (or irqsave I guess).
>>
> Correct, both of the above are only every called from process context,
> so a simple conversion to spin_lock_irq() for these two, and
> spin_lock_irqsave() in transport_lookup_tmr_lun() should by sufficent..
Likewise, we need to do same change in function 
"transport_get_lun_for_tmr", specifically for tmr_lock. Please correct 
me if I am missing anything.
> --nab
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,
-- Kiran P.
