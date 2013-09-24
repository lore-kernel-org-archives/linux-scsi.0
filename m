From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] SCSI's heuristics for enabling WRITE SAME still need
 work [was: dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 07:39:13 +0200
Message-ID: <52412581.2010909@suse.de>
References: <20130919161043.GA27081@redhat.com> <20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net> <1379960325.4010.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab3IXFjP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 01:39:15 -0400
In-Reply-To: <1379960325.4010.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>

On 09/23/2013 08:18 PM, Ewan Milne wrote:
> On Fri, 2013-09-20 at 18:03 -0400, Martin K. Petersen wrote:
> ...
>> Only a handful of the very latest and greatest devices support RSOC.=
 The
>> number of devices that support WRITE SAME is orders of magnitude lar=
ger.
>>
>> Last I checked I had exactly 1 out of about 100 devices in my lab th=
at
>> supported RSOC.
> ...
>> The major headache here of course is that WRITE SAME is inherently
>> destructive. We can't just fire off one during discovery and see if =
it
>> works. For WRITE you can issue a command with a transfer length of 0=
 to
>> see if things work. But unfortunately for WRITE SAME a transfer leng=
th
>> of zero means "wipe the entire device". Yikes!
>>
>> I guess we could read one sector and try to write it back using WRIT=
E
>> SAME and a block count of one. But it's really icky. And I don't lik=
e
>> the notion of actually writing things during discovery.
> ...
>=20
> Just out of curiosity, what do the devices that support WRITE SAME
> report for the MAXIMUM WRITE SAME LENGTH field in VPD page B0?  The
> spec says that this can be zero if there is no restriction, but is
> there any chance that most/all of them report some nonzero value?
>=20
> Expanding on Doug's thinking, perhaps there is some combination of
> VPD page availability / field values that could be used to explicitly
> enable WRITE SAME?  Or, have you been through that already?
>=20
Hehe. Won't do any good.

My drives support 'report opcodes', and report that write same is
supported:
=2E..
 93                 16    Write same(16)
=2E..

but no support for page 'b0'. And yes, these are real SAS drives.

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
