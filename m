From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 18 Mar 2009 19:30:33 +0100
Message-ID: <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:61977 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZCRSft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 14:35:49 -0400
Received: by ewy9 with SMTP id 9so149070ewy.37
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 11:35:46 -0700 (PDT)
In-Reply-To: <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@hansenpartnership.com

On Wed, Mar 18, 2009 at 02:36, Chandra Seetharaman <sekharan@us.ibm.com=
> wrote:
> From: Peter Jones <pjones@redhat.com>
>
> This patch allows the use of modaliases on scsi targets to correctly
> load scsi device handler modules when the devices are found.
> +++ linux-2.6.28/include/linux/mod_devicetable.h
> @@ -454,4 +454,10 @@ struct dmi_system_id {
>
> =C2=A0#define DMI_MATCH(a, b) =C2=A0 =C2=A0 =C2=A0 =C2=A0{ a, b }
>
> +struct scsi_dh_device_id {
> + =C2=A0 =C2=A0 =C2=A0 unsigned char type;
> + =C2=A0 =C2=A0 =C2=A0 char vendor[9];
> + =C2=A0 =C2=A0 =C2=A0 char model[17];
> +};

Doesn't the static array waste space, when used for the long lists of
entries stuffed in arrays of this structure? It will carry a lot of \0
chars, and identical strings can not be de-duplicated by the compiler,
unlike when pointers are used?

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
