From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Reject immediate data underflow larger
 than SCSI transfer length
Date: Thu, 08 Jun 2017 23:55:02 -0700
Message-ID: <1496991302.28997.66.camel@haakon3.risingtidesystems.com>
References: <1496895685-18464-1-git-send-email-nab@linux-iscsi.org>
         <1496936253.3028.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496936253.3028.1.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "roland@purestorage.com" <roland@purestorage.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-06-08 at 15:37 +0000, Bart Van Assche wrote:
> On Thu, 2017-06-08 at 04:21 +0000, Nicholas A. Bellinger wrote:
> > +	/*
> > +	 * Check for underflow case where both EDTL and immediate data payload
> > +	 * exceeds what is presented by CDB's TRANSFER LENGTH, and what has
> > +	 * already been set in target_cmd_size_check() as se_cmd->data_length.
> > +	 *
> > +	 * For this special case, fail the command and dump the immediate data
> > +	 * payload.
> > +	 */
> > +	if (cmd->first_burst_len > cmd->se_cmd.data_length) {
> > +		cmd->sense_reason = TCM_INVALID_CDB_FIELD;
> > +		goto after_immediate_data;
> > +	}
> 
> A quote from the iSCSI RFC (https://tools.ietf.org/html/rfc5048):
> 
>    If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the
>    SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST
>    be set to the numerical value of (EDTL - SPDTL).
> 
> Sorry but I don't think that sending TCM_INVALID_CDB_FIELD back to the
> initiator is compliant with the iSCSI RFC.

Alas, the nuance of what this patch actually does was missed when you
cut the context.

First, a bit of history.  LIO has rejected underflow for all WRITEs for
the first ~12.5 years of RFC-3720, and in the context of iscsi-target
mode there has never been a single host environment that ever once
cared.

Since Roland's patch to allow underflow for control CDBs in v4.3+ opened
this discussion for control CDBs with a WRITE payload in order to make
MSFT/FCP cert for PERSISTENT_RESERVE_OUT happy, the question has become
what control CDB WRITE underflow cases should we allow..?

The point with this patch is when a host is sending a underflow with a
iscsi immediate data payload that exceeds SCSI transfer length, it's a
bogus request with a garbage payload.  It's a garbage payload because
the SCSI CDB itself obviously doesn't want anything to do it.

I'm very dubious of any host environment who's trying to do this for any
CDB, and expects achieve expected results.

Of course, since v4.3+ normal overflow where SCSI transfer length
matches the iscsi immediate data payload just works with or without this
patch.

So to that extent, I'm going to push this patch as a defensive fix for
v4.3+, to let those imaginary iscsi host environments know they being
very, very naughty.

>  Please note that a fix that is
> compliant with the iSCSI RFC is present in the following patch series: [PATCH
> 00/33] SCSI target driver patches for kernel v4.13, 23 May 2017
> (https://www.spinics.net/lists/target-devel/msg15370.html).

So I might still consider this as a v4.13-rc item for control CDB
underflow, but no way as stable material.

Also, there is certainly no way I'm going to allow a patch to randomly
enable underflow/overflow for all WRITE non control CDBs tree-wide
across all fabric drivers, because 1) no host environments actually care
about this, and 2) it's still dangerous to do for all fabrics without
some serious auditing.
