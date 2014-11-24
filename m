From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] aic94xx: Fixup compilation warning
Date: Mon, 24 Nov 2014 17:34:38 +0100
Message-ID: <54735E1E.2070502@redhat.com>
References: <1415085059-127936-1-git-send-email-hare@suse.de>	 <20141124134014.GA22128@infradead.org> <547356F6.3070404@redhat.com> <1416845409.2194.7.camel@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbaKXQfN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 11:35:13 -0500
In-Reply-To: <1416845409.2194.7.camel@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>

On 11/24/2014 05:10 PM, James Bottomley wrote:
> On Mon, 2014-11-24 at 17:04 +0100, Tomas Henzl wrote:
>> On 11/24/2014 02:40 PM, Christoph Hellwig wrote:
>>> Can someone review this trivial patch for me?  Thanks!
>>>
>> The compiler complains because when asd_find_flash_de fails, the off=
s is not initialized.
>> When that happens this code is invoked :
>>         if (err) {
>>                 ASD_DPRINTK("couldn't find CTRL-A user settings sect=
ion\n");
>>                 ASD_DPRINTK("Creating default CTRL-A user settings s=
ection\n");
>>
>>                 dflt_ps.id0 =3D 'h';
>>                 dflt_ps.num_phys =3D 8;
>>                 for (i =3D0; i < ASD_MAX_PHYS; i++) {
>>                         memcpy(dflt_ps.phy_ent[i].sas_addr,
>>                                asd_ha->hw_prof.sas_addr, SAS_ADDR_SI=
ZE);
>>                         dflt_ps.phy_ent[i].sas_link_rates =3D 0x98;
>>                         dflt_ps.phy_ent[i].flags =3D 0x0;
>>                         dflt_ps.phy_ent[i].sata_link_rates =3D 0x0;
>>                 }
>>
>>                 size =3D sizeof(struct asd_ctrla_phy_settings);
>>                 ps =3D &dflt_ps;
>> the dflt_ps is initialized and the address assigned to 'ps', but non=
e of them is used later
>>  }
>>
>>         if (size =3D=3D 0)
>>                 goto out;
>>
>>         err =3D -ENOMEM;
>>         el =3D kmalloc(size, GFP_KERNEL);
>>         if (!el) {
>>                 ASD_DPRINTK("no mem for ctrla user settings section\=
n");
>>                 goto out;
>>         }
>>
>>         err =3D asd_read_flash_seg(asd_ha, (void *)el, offs, size);
>>         if (err) {
>>                 ASD_DPRINTK("couldn't read ctrla phy settings sectio=
n\n");
>>                 goto out2;
>>         }
>>
>>         err =3D -ENOENT;
>>         ps =3D asd_find_ll_by_id(el, 'h', 0xFF);
>> here^ a new value is assigned to 'ps'
>>
>>
>> I have no idea what was intended in the originally so - it looks lik=
ely, but how do we know that
>> the '0' is a correct value for offs?
> Yes, it seems to be the default from the hw ... if you don't have any
> nvram then the phy setting are up first.
>
>> Probably the error path is never used, this patch should fix the gcc=
 warning too -
>> @@ -990,20 +990,7 @@ static int asd_process_ctrl_a_user(struct asd_h=
a_struct *asd_ha,
>>  	err =3D asd_find_flash_de(flash_dir, FLASH_DE_CTRL_A_USER, &offs, =
&size);
>>  	if (err) {
>>  		ASD_DPRINTK("couldn't find CTRL-A user settings section\n");
>> -		ASD_DPRINTK("Creating default CTRL-A user settings section\n");
>> -
>> -		dflt_ps.id0 =3D 'h';
>> -		dflt_ps.num_phys =3D 8;
>> -		for (i =3D0; i < ASD_MAX_PHYS; i++) {
>> -			memcpy(dflt_ps.phy_ent[i].sas_addr,
>> -			       asd_ha->hw_prof.sas_addr, SAS_ADDR_SIZE);
>> -			dflt_ps.phy_ent[i].sas_link_rates =3D 0x98;
>> -			dflt_ps.phy_ent[i].flags =3D 0x0;
>> -			dflt_ps.phy_ent[i].sata_link_rates =3D 0x0;
>> -		}
>> -
>> -		size =3D sizeof(struct asd_ctrla_phy_settings);
>> -		ps =3D &dflt_ps;
>> +		goto out;
> I did think about that.  There does seem to be a definite reason to
> expect the phy setting read to succeed even though the nvram read
> failed.  I think the reason was that there were some aic94xx cards th=
at
> had no nvram and therefore always failed the read, but I can't find a=
ny
> evidence of that any more.

The dead code there brought me to the idea that the error path was not =
much used...
Using a '0' is at least so good as some random value, so I'm fine
with your or Hannes's patch.

>
> James
>
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
