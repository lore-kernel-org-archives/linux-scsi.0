From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] libsas: fix definition of wideport, include local sas address
Date: Mon, 4 Oct 2010 09:44:11 -0700
Message-ID: <AANLkTi=rM=7r6tnxCrc42q=e6r0U2LKPyoUa-D5j3MKa@mail.gmail.com>
References: <20101001205552.30032.87278.stgit@localhost.localdomain>
	<35DEA0DE11CB42F8B788D1C3C4E7BBA0@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:41513 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab0JDQoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2010 12:44:11 -0400
Received: by pxi10 with SMTP id 10so1382581pxi.19
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2010 09:44:11 -0700 (PDT)
In-Reply-To: <35DEA0DE11CB42F8B788D1C3C4E7BBA0@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: james.bottomley@suse.de, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Patrick Thomson <patrick.s.thomson@intel.com>, linux-scsi@vger.kernel.org

On Sat, Oct 2, 2010 at 6:55 PM, Jack Wang <jack_wang@usish.com> wrote:
>
> To date libsas has only looked at the attached sas address when
> determining the formation of wide ports. =A0The specification and som=
e
> hardware expects that phys with different addresses will not form a w=
ide
> port unless the local peer phys also match each other. =A0Introduce a=
 flag
> to select stricter behavior at sas_register_ha() time. =A0The flag ca=
n be
> dropped once it is known that all libsas users expect the same behavi=
or.
>
> Current drivers just initialize this field to zero and get the
> traditional behavior.
> [Jack] I prefer to use the new definition of wideport to the default.

Ok, when mvsas and aic94xx are also ready for this change we can just
make this the default and kill the flag.

> [Jack] I cann't find where to judge the flag to chose which definitio=
n to
> use?

I am not clear on the question.  phy_is_wideport_member() should be
the only location that needs to read this flag.  The driver just sets
it to 1 before calling sas_register_ha() and then assumes the strict
definition is in effect for the lifetime of the driver instance.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
