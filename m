From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/11] qla4xxx: Added support for ISP82XX
Date: Wed, 16 Jun 2010 17:02:41 -0500
Message-ID: <4C194A01.1080809@cs.wisc.edu>
References: <20100616205403.GA8178@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55121 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab0FPWAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 18:00:22 -0400
In-Reply-To: <20100616205403.GA8178@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, karen.higgins@qlogic.com

On 06/16/2010 03:54 PM, Vikas Chaudhary wrote:
>   	} else {
>   		DEBUG2(printk("scsi%ld: Unknown mailbox status %08X\n",
>   			      ha->host_no, mbox_status));
>
> -		ha->mbox_status[0] =3D mbox_status;
> +		ha->mbox_status[0] =3D mbox_sts[0];
>   	}
>   }

Is this right? mbox_sts[0] is not set at this point, and you get:

drivers/scsi/qla4xxx/ql4_isr.c: In function =91qla4xxx_isr_decode_mailb=
ox=92:
drivers/scsi/qla4xxx/ql4_isr.c:634: warning: =91mbox_sts=92 may be used=
=20
uninitialized in this function

We should not hit the case though, right. Maybe in a follow up patch yo=
u=20
can fix this since the rest of the patches look ok, and I do not want t=
o=20
look a them ever again :)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
