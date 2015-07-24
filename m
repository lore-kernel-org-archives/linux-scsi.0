From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] target: add support for START_STOP_UNIT SCSI opcode
Date: Fri, 24 Jul 2015 03:06:12 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295AA06D79@G9W0745.americas.hpqcorp.net>
References: <1437516477-30554-1-git-send-email-sbaugh@catern.com>
 <20150723093618.GA5382@infradead.org> <877fpqfr19.fsf@ponos.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877fpqfr19.fsf@ponos.purestorage.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Brian Bunker <brian@purestorage.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Spencer Baugh
> Sent: Thursday, July 23, 2015 5:28 PM
> To: Christoph Hellwig <hch@infradead.org>; Spencer Baugh
> <sbaugh@catern.com>
...
> Subject: Re: [PATCH] target: add support for START_STOP_UNIT SCSI opcode
> 
> From: Brian Bunker <brian@purestorage.com>
> 
> AIX servers using VIOS servers that virtualize FC cards will have a
> problem booting without support for START_STOP_UNIT.
> 
> v2: Cite sb3r36 exactly, clean up if conditions
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Spencer Baugh <sbaugh@catern.com>
...
> v2: Cite sb3r36 exactly, clean up if conditions
> 
...
> diff --git a/drivers/target/target_core_sbc.c
> b/drivers/target/target_core_sbc.c
> index e318ddb..85c3c0a 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -154,6 +154,38 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
>  	return 0;
>  }
> 
> +static sense_reason_t
> +sbc_emulate_startstop(struct se_cmd *cmd)
> +{
> +	unsigned char *cdb = cmd->t_task_cdb;
> +
> +	/*
> +	 * See sb3r36 section 5.25

Global typo in this patch - sb3 should be sbc3.

Editorial comment:
Note that the officially published versions of the ISO and ANSI 
standards don't carry that revision number r36; they just have
the standard name and year.  SBC-3 revision 36 became 
"ANSI INCITS 514-2014 Information technology - SCSI Block 
Commands - 3 (SBC-3)".

T10 isn't really obligated to keep making particular working 
drafts available, although the ones that have been assigned
version descriptors (in SPC-n) are more likely to stick 
around.  For SBC-3, only revisions 35 and 36 earned those.

Section numbers are quite volatile, too, so you might be
better off including the section name.  It's starting to
become standardese, but this kind of wording might be better:

"See the SBC-3 START STOP UNIT command description
(e.g., sbc3r36 5.25)"

> +	/* From SBC-3:
> +	 * Immediate bit should be set since there is nothing to complete
> +	 * POWER CONDITION MODIFIER 0h
> +	 */
> +	if (!(cdb[1] & 1) || (cdb[2] | cdb[3]))
> +		return TCM_INVALID_CDB_FIELD;

Technical comment:
The application client is not obligated to set the IMMED bit here.
In fact, that's an unusual choice.  Using the IMMED bit means the 
application client must handle the initial status for the 
command, then poll for the functional results with REQUEST SENSE
and TEST UNIT READY commands, which is much more complicated.
