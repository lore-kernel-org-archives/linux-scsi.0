From: Ryan Attard <rattard@cleversafe.com>
Subject: Odd Behavior in the enclosure module around the 2 fault bits
Date: Wed, 30 Sep 2015 15:17:23 +0000
Message-ID: <BN1PR04MB076C498417786FF22C034A1CB4D0@BN1PR04MB076.namprd04.prod.outlook.com>
References: <BN1PR04MB07626753646D0AB2BBD9FF9CB4E0@BN1PR04MB076.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0054.outbound.protection.outlook.com ([65.55.169.54]:9192
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932396AbbI3Qts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 12:49:48 -0400
In-Reply-To: <BN1PR04MB07626753646D0AB2BBD9FF9CB4E0@BN1PR04MB076.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


My coworkers and I were setting some enclosure states on our storage de=
vices, and then reading the states back using sysfs, and came across th=
e 'fault' field being set to 2. When we investigated into the ses.c fil=
e, we found=A0this  wonderful comment:

/* For device slot and array device slot elements, byte 3 bit 6
=A0* is "fault sensed" while byte 3 bit 5 is "fault reqstd". As this
=A0* code stands these bits are shifted 4 positions right so in
=A0* sysfs they will appear as bits 2 and 1 respectively. Strange. */
static void ses_get_fault(struct enclosure_device *edev,
			 =A0struct enclosure_component *ecomp)
{
	unsigned char *desc;


	desc =3D ses_get_page2_descriptor(edev, ecomp);
	if (desc)
		ecomp->fault =3D (desc[3] & 0x60) >> 4;
}

I was hoping there might be an explanation=A0(purely for curiosity's sa=
ke) why it was not shifted 5 positions? Or why it wasn't exported as 2 =
fields in sysfs, each representing 1 bit in the SES page?=A0

Thanks,
Ryan Attard


     --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
