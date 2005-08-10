From: Frederic TEMPORELLI - astek <ftemporelli@astek.fr>
Subject: Re: [PATCH] remove name length check in a workqueue
Date: Wed, 10 Aug 2005 20:49:40 +0200
Message-ID: <42FA4C44.5040609@astek.fr>
References: <1123683544.5093.4.camel@mulgrave>	 <Pine.LNX.4.58.0508101044110.31617@devserv.devel.redhat.com>	 <20050810100523.0075d4e8.akpm@osdl.org> <1123694672.5134.11.camel@mulgrave>	 <20050810103733.42170f27.akpm@osdl.org> <1123696466.5134.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailfe09.tele2.fr ([212.247.155.12]:47260 "EHLO swip.net")
	by vger.kernel.org with ESMTP id S965257AbVHJStx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 14:49:53 -0400
In-Reply-To: <1123696466.5134.23.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley a =E9crit :

>Well, but the other alternative is that we hit arbitrary BUG_ON() limi=
ts
>in systems that create numbered workqueues which is rather contrary to
>our scaleability objectives, isn't it?
>
>I think I'd rather the name truncation than have to respond to kernel
>BUG()'s.  If someone really has a problem with the appearance of ps,
>they can always increase TASK_COMM_LEN.
>
> =20
>
>>We could truncate the name before adding the CPU number, but it sound=
s
>>saner to just prevent anyone passing in excessively long names.  Via
>>BUG_ON, say ;)
>>
>>What's the actual problem?
>>   =20
>>
>
>What I posted originally; the current SCSI format for a workqueue:
>scsi_wq_%d hits the bug after the host number rises to 100, which has
>been seen by some enterprise person with > 100 HBAs.
>
>The reason for this name is that the error handler thread is called
>scsi_eh_%d; so we could rename all our threads to avoid this, but one
>day someone will come along with a huge enough machine to hit whatever
>limit we squeeze it down to.
>
>James
>
> =20
>
In scsi layer (drivers/scsi/hosts.c), wq name length is limited to=20
KOBJ_NAME_LEN due to the snprintf .
may be nice to use same limit if BUG_ON is kept... but why NULL isn't=20
returned, then ?  ;-)

--
Tempo
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
