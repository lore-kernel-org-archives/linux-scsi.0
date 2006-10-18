From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH RFC] replace dm hw handlers with scsi handlers
Date: Wed, 18 Oct 2006 16:33:25 +0200
Message-ID: <20061018143324.GB25084@pentland.suse.de>
References: <1160684310.4163.4.camel@madmax> <4530E19A.8040002@cs.wisc.edu> <1161074225.6464.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:24028 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1161037AbWJROda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 10:33:30 -0400
Content-Disposition: inline
In-Reply-To: <1161074225.6464.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

Hi Mike,

On Tue, Oct 17, 2006 at 10:37:05AM +0200, Christophe Varoqui wrote:
> Le samedi 14 octobre 2006 =C3=A0 09:09 -0400, Mike Christie a =C3=A9c=
rit :
> > Christophe V, I was wondering what is the vendor/module info for yo=
ur
> > box? We have a MSA1000 VOLUME/COMPAQ here, but START_STOP does not
> > work.
> > I mean if I send the command it always executes successfully, but t=
he
> > device does not failover (READ/WRITEs fail). I tried just running
> > sg_start and this runs ok but READ/WRITE still fail, so I hacked up
> > scsi_debug to simulate my testing.=20
>=20
> It was a HSG80 based array, namely a HP EMA8000.
> I do not have access to this hardware anymore.
>=20

Hmm. Finally I got a MSA1000 here, too (Thanks, HP!). dm_hp_sw seems
to work properly there. Note that according to the HP qla2xxx sources
the MSA1000 might take some time to actually do the switchover.
Appearently they return NOT_READY / UNIT_ATTENTION and some weird statu=
s
in byte 12 & 13 of the sense buffer (!). So please check the sense code
if there is anything untoward.
Oh, and you can check whether the failover really occured by using
the management console; 'show this_controller' and 'show other_controll=
er'
will tell you which one's active.
Drop me a mail if you got further questions.=20

Apart from this: good work!

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=EF=BF=BDe 5				+49 911 74053 688
90409 N=EF=BF=BDrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
