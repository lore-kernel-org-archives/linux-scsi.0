From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re: st driver doesn't seem to grok LTO partitioning
Date: Mon, 1 Feb 2016 20:43:26 +0200
Message-ID: <5A3F5643-16A4-4010-B3D2-3F931B620128@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr> <20160104124626.3112e8c0@harpe.intellique.com> <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com> <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com> <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com> <20160106170720.61db9e86@harpe.intellique.com> <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net> <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44
 522A7B@G9W0766.americas.hpqcorp.net> <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net> <alpine.LSU.2.11.1601291915010
 .22105@x
 nv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB4452416B@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:35225 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbcBASne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 13:43:34 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB4452416B@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On 1.2.2016, at 8.31, Seymour, Shane M <shane.seymour@hpe.com> wrote:
> 
> Hi Kai,
> 
> Thanks for the changes the HPE DAT72 DDS5 drive now works as expected:
> 
Good. Thanks for testing.

...
> 
> I'm asking around again one final time to see if I can lay my hands on a LTO5 or greater drive so I can test LTO partitioning as well.
> 
> The only other thing I can think of (I'm not sure if this is an improvement or not) is if bp[pgo + PP_OFF_MAX_ADD_PARTS] + bp[pgo + PP_OFF_NBR_ADD_PARTS] (max.parts and nbr_parts in the debug message) is zero just return -EINVAL unless you know of any take drives that report them both as 0 but can be partitioned? That is after this:
> 
>        DEBC_printk(STp, "psd_cnt %d, max.parts %d, nbr_parts %d\n",
>                    psd_cnt, bp[pgo + PP_OFF_MAX_ADD_PARTS],
>                    bp[pgo + PP_OFF_NBR_ADD_PARTS]);
> 
> add (and also turn off the can-partitions option):
> 
> 	if ((bp[pgo + PP_OFF_MAX_ADD_PARTS] + bp[pgo + PP_OFF_NBR_ADD_PARTS]) == 0) {
> 		DEBC_printk(STp, "Drive not partitionable - max.parts+nbr_parts is 0\n");
> 		STp->can_partitions = 0;
> 		return -EINVAL;
> 	}
> 
> I'm not especially fussed if you don't want to add that though.
> 
I thought about a test like this (only test maximum number) but decided not to add it. The reason was that
I did not want to change anything that has worked before. I quite trust that the current drives return sense
data instead of crashing and the end result for the user would be the same. However, one can argue that
returning EINVAL is better than EIO but does the user notice? If the common opinion is that a test like this
should be added, I am not against it. It can be added to the code for SCSI >=3 where it does not risk
anything for the old drives.

IMHO, can_partitions should not be cleared based on the test. For example, trying to partition a LTO-4 tape
in a LTO-5 drive should not disable partitioning. (The mode page should return zero as maximum number of
partitions when a LTO-4 tape is inserted.)

Thanks,
Kai

