From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: add support for START_STOP_UNIT SCSI opcode
Date: Thu, 23 Jul 2015 02:36:18 -0700
Message-ID: <20150723093618.GA5382@infradead.org>
References: <1437516477-30554-1-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437516477-30554-1-git-send-email-sbaugh@catern.com>
Sender: target-devel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Brian Bunker <brian@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 21, 2015 at 03:07:53PM -0700, Spencer Baugh wrote:
> +static sense_reason_t
> +sbc_emulate_startstop(struct se_cmd *cmd)
> +{
> +	unsigned char *cdb = cmd->t_task_cdb;
> +
> +	/* From SBC-3:
> +	 * Immediate bit should be set since there is nothing to complete
> +	 * POWER CONDITION MODIFIER 0h
> +	 */

Mot of the target code mentions the exact document and section, e.g.

drivers/target/target_core_alua.c: * See sbc3r35 section 5.23
drivers/target/target_core_sbc.c:        * Set Thin Provisioning Enable bit following sbc3r22 in section
drivers/target/target_core_sbc.c:        * From sbc3r22.pdf section 5.48 XDWRITEREAD (10) command

Also if you fix thing up anyway the Linux style is to keep the opening
"/*" on a separate line.

> +	if (!(cdb[1] & 1) || (cdb[2] | cdb[3]))
> +		return TCM_INVALID_CDB_FIELD;

The mix of || and | here is odd, why not just:

 if (!(cdb[1] & 1) || cdb[2] || cdb[3])

> +	if (!(cdb[4] & 1) || ((cdb[4] & 2) | (cdb[4] & 4)))

Same here.

But except for this nitpicking the patch looks good:


Reviewed-by: Christoph Hellwig <hch@lst.de>
