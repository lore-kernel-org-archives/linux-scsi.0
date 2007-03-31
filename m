From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Sun, 01 Apr 2007 01:14:15 +0900
Message-ID: <460E88D7.3010702@gmail.com>
References: <460CDBA6.5030608@gmail.com>	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>	<460D0E78.3040200@gmail.com>	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>	<460D178F.4000500@gmail.com>	<20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>	<460D27E3.2050602@gmail.com>	<20070330213101.7aa7babf@gondolin.boeblingen.de.ibm.com>	<460DD1B0.4080605@gmail.com> <20070331180806.55d572c8@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070331180806.55d572c8@gondolin.boeblingen.de.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Cornelia Huck wrote:
> On Sat, 31 Mar 2007 12:12:48 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>>> Hm, but as long as dk0 is registered, it can be looked up and someone
>>> could get a reference on it.
>> Yeah, exactly.  That's why any getting any kobject reference backed by a
>> module must be accompanied by try_module_get().
>>
>> int mydrv_get_dk(struct dk *dk)
>> {
>> 	rc = try_module_get(mydrv);
>> 	if (rc)
>> 		return rc;
>> 	kobject_get(&dk->kobj);
>> 	return 0;
>> }
> 
> This works if the caller always knows which module to grab (I was
> thinking about some tree-walking code).

Yeah, that's why we have so many ->owner's and getting it wrong results 
in jumping to non-existent address.

-- 
tejun
