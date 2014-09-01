From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/22] scsi: remove obsolete __scsi_print_command() usages
Date: Mon, 01 Sep 2014 08:56:06 +0200
Message-ID: <54041886.6090703@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-13-git-send-email-hare@suse.de> <20140831221809.GH16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIAG4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 02:56:09 -0400
In-Reply-To: <20140831221809.GH16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/01/2014 12:18 AM, Christoph Hellwig wrote:
> Can you change the subject a bit?  There's nothing obsolete in
> __scsi_print_command, you're just moving it to a higher level helper.
>=20
>>  #if defined(AHA152X_DEBUG)
>>  	if (HOSTDATA(shpnt)->debug & debug_queue) {
>> -		printk(INFO_LEAD "queue: %p; cmd_len=3D%d pieces=3D%d size=3D%u c=
mnd=3D",
>> -		       CMDINFO(SCpnt), SCpnt, SCpnt->cmd_len,
>> -		       scsi_sg_count(SCpnt), scsi_bufflen(SCpnt));
>> -		__scsi_print_command(SCpnt->cmnd);
>> +		scmd_printk(KERN_INFO, SCpnt,
>> +			    "queue: %p; cmd_len=3D%d pieces=3D%d size=3D%u\n",
>> +			    SCpnt, SCpnt->cmd_len,
>> +			    scsi_sg_count(SCpnt), scsi_bufflen(SCpnt));
>> +		scsi_print_command(SCpnt);
>=20
> This also has a printk -> scmd_printk change that's unrelated to the
> patch.
>=20
> Honestly I think we should just kill much of the AHA152X_DEBUG code a=
t
> the start of this series to avoid all the churn in it.
>=20
I'm all for it.
The 152x is a _really_ old card (that's the one which used to get
shipped with the old parallel SCSI scanner, before they switched
to ncr53c4xx) and it's ISA only. So the overall exposure will be
rather limited, and I sincerely doubt anyone will be missing the
debugging stubs.
Will be removing them with the next patchset.

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
