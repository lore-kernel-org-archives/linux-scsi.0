From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/22] scsi: consolidate scsi_print_status()
Date: Mon, 01 Sep 2014 10:46:20 +0200
Message-ID: <5404325C.2020605@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-11-git-send-email-hare@suse.de> <20140831221439.GF16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbaIAIqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 04:46:21 -0400
In-Reply-To: <20140831221439.GF16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/01/2014 12:14 AM, Christoph Hellwig wrote:
>>  #if defined(AHA152X_DEBUG)
>> -	if (HOSTDATA(shpnt)->debug & debug_status) {
>> -		printk(DEBUG_LEAD "inbound status %02x ", CMDINFO(CURRENT_SC), CU=
RRENT_SC->SCp.Status);
>> -		scsi_print_status(CURRENT_SC->SCp.Status);
>> -		printk("\n");
>> -	}
>> +	if (HOSTDATA(shpnt)->debug & debug_status)
>> +		printk(DEBUG_LEAD "inbound status %02x\n", CMDINFO(CURRENT_SC), C=
URRENT_SC->SCp.Status);
>=20
> This one just removes the call.  While this is fine with me it needs =
to
> be mentioned in the changelog.
>=20
> Also if you change the line above it please make sure it fits into an
> 80 character line.
>=20
>> +const char *
>>  scsi_print_status(unsigned char scsi_status) {
>> -#ifdef CONFIG_SCSI_CONSTANTS
>=20
> Please explain in the changelog why you're removing this ifdef.
>=20
>> +	case SAM_STAT_BUSY:
>> +		ccp =3D "Busy"; break;
>=20
> Please put the break statements on separate lines per normal Linux
> style.
>=20
>>  #define scsi_prot_op_name(result)	{ result, #result }
>>  #define show_prot_op_name(val)					\
>>  	__print_symbolic(val,					\
>> @@ -331,7 +316,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_templa=
te,
>>  		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
>>  		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
>>  		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
>> -		  show_statusbyte_name(__entry->result & 0xff))
>> +		  scsi_print_status(__entry->result & 0xff))
>=20
>=20
> Not using __print_symbolic for trace events breaks all tracing tools
> that parse the binary trace buffers, please drop the tracing changes
> (which weren't mentioned in the changelog anyway and should have been=
 a
> separate patch).
>=20
I've now taken another approach; I've updated the logging functions
aha152x.c and removed all debugging code. And with that we can
remove scsi_print_status() altogether.

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
