Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D9643231F;
	Mon, 27 Jul 2026 20:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785184860; cv=none; b=ltUXcmWLOMW66grW8v3O/h9fEmLI1e+FhIzRXOp2wWgZtqyING2qiUAZ2schnrlbZjzNivtixNMGqfHw5Yc020kshHDsY1FHIdS0pCAkaxOqbQQBBQo9+oYmDPpWCTQ7/PrAi6wspM84rSj2Hp1pyYPL4eS/hS4kL41e0s3hVgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785184860; c=relaxed/simple;
	bh=2NbbooRyXe3g8iNYErBgq130SL+Q1td6ph4XuIVBN2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+9uhPVQJpw1xSbCqek+bqNBx+qX4iEppuk6OZBU4rRRqT4P0/QpUBU1JiAg2PzWfVBjICoezbr4PErMLx20uBhe/qreInnBskfaMMFoKIP4dyLvIScMbFa8UsGslD9rS9oZCQA+3soY1ODpInSkbY9Mr51REALeB/oIdOtD9Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9AZxY3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9AZxY3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716251F00A3E;
	Mon, 27 Jul 2026 20:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785184858;
	bh=j4iH9xFCazjvMHgWdG8xvMkYk8EpIQraJeYNev6OkBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y9AZxY3kzC5PFpqp0VSh5NL8rdB3MM9OD4gUL0XIERkytH5jGs0IIvH/GlRDynMjN
	 FXdXosNTHWpTpY0xu0Ph5gi4EgEMoOp6Z1hp+SVW8U/VUEMAX+yoOL506E+8XfJdwf
	 lCIIA8jQYRH68WAponqsIOyIUlVvlJbvns3eD192iEaPTkxfH9APL8Wrz9lEAZxWac
	 K4x8zby0k6LGURuwVuXymfbrtv91t8CZyH/RnPW0hJCZXQi1WeDdgJIfObQoIOZB/4
	 xIFKo98BukUt5/j77kwNYjhhT7q0XIFq9BGAK+eqAOgA30Q/9w35b3rDb6ceZ94/d+
	 On4qYpaaZLaBg==
Date: Mon, 27 Jul 2026 22:40:55 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <amfCVx43BCYFWFFY@ryzen>
References: <20260721064027.2081195-1-dlemoal@kernel.org>
 <20260721064027.2081195-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721064027.2081195-2-dlemoal@kernel.org>

On Tue, Jul 21, 2026 at 03:40:26PM +0900, Damien Le Moal wrote:
> @@ -1685,26 +1685,75 @@ void ata_scsi_deferred_qc_work(struct work_struct *work)
>  	spin_unlock_irqrestore(ap->lock, flags);
>  }
>  
> -void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
> +enum scsi_timeout_action ata_scsi_requeue_deferred_qc(struct ata_port *ap,
> +						struct scsi_cmnd *timedout_scmd)
>  {
> +	enum scsi_timeout_action action = SCSI_EH_NOT_HANDLED;
> +	struct ata_queued_cmd *qc;
>  	struct ata_link *link;
> +	u32 host_byte;
>  
>  	lockdep_assert_held(ap->lock);
>  
>  	/*
> -	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
> -	 * do not try to be smart about what to do with this deferred command
> -	 * and simply requeue it by completing it with DID_REQUEUE.
> +	 * If we have deferred QCs when a reset, a timeout or an NCQ command
> +	 * fails, do not try to be smart about what to do with the deferred
> +	 * commands and simply terminate them and let the SCSI layer decide
> +	 * what to do.
>  	 */
>  	ata_for_each_link(link, ap, PMP_FIRST) {
> -		struct ata_queued_cmd *qc = link->deferred_qc;
> +		qc = link->deferred_qc;
> +		if (!qc)
> +			continue;
> +
> +		/*
> +		 * Clear the deferred QC so that the deferred work does not try
> +		 * to issue it.
> +		 */
> +		link->deferred_qc = NULL;
> +		cancel_work(&link->deferred_qc_work);
> +
> +		/*
> +		 * We are going to complete some scsi command, either with
> +		 * DID_TIME_OUT if the command timed out while waiting for being
> +		 * issued, or with DID_REQUEUE if another command timed out or
> +		 * we had a failed command. However, the block layer may re-issue
> +		 * immediately these commands, keeping the scsi host busy and
> +		 * thus preventing the SCSI EH task from running.
> +		 * So schedule EH on the port to prevent accepting new commands
> +		 * until everything is sorted out with the error or timeout that
> +		 * got us here in the first place. Note that we set EH pending
> +		 * on the port before calling ata_port_schedule_eh() so that we
> +		 * do not reenter this function from ata_eh_set_pending() with
> +		 * timedout_scmd being NULL and erroneously retry deferred QCs
> +		 * that have timed out on other links.
> +		 */
> +		if (!ata_port_eh_scheduled(ap)) {
> +			ap->pflags |= ATA_PFLAG_EH_PENDING;
> +			ata_port_schedule_eh(ap);
> +		}
>  
> -		if (qc) {
> -			link->deferred_qc = NULL;
> -			cancel_work(&link->deferred_qc_work);
> -			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
> +		/*
> +		 * If we are being called from scsi_timeout(), then we have a
> +		 * non-NULL timedout_scmd. If the timed out command is for a
> +		 * deferred qc, terminate it with DID_TIME_OUT and tell
> +		 * scsi_timeout() that we are done. Otherwise, ask for a retry
> +		 * with DID_REQUEUE and tell scsi_timeout() that we have not
> +		 * handled the timeout so that the timed out command gets added
> +		 * to the EH work queue with scsi_eh_scmd_add(), for later
> +		 * handling with libata EH ata_scsi_cmd_error_handler().
> +		 */
> +		if (qc->scsicmd != timedout_scmd) {
> +			qc->scsicmd->allowed++;
> +			host_byte = DID_REQUEUE;
> +		} else {
> +			host_byte = DID_TIME_OUT;
> +			action = SCSI_EH_DONE;
>  		}
> +		ata_scsi_qc_done(qc, true, host_byte << 16);

Might be a quite subtle difference, but I think it is much clearer if you
would instead write this as:

		if (timedout_scmd && qc->scsicmd == timedout_scmd) {
			host_byte = DID_TIME_OUT;
			action = SCSI_EH_DONE;
		} else {
			host_byte = DID_REQUEUE;
		}
		ata_scsi_qc_done(qc, true, host_byte << 16);


Because that more clearly highlights the special case.
(And is more in line with my suggested comment, so it also makes it easier
to corroborate the comment with the actual code.)

The special case is if timedout_scmd is non-NULL AND is the deferred QC.

For all other cases, if timedout_scmd is non-NULL but is not the deferred
QC, or if the timedout_cmd is NULL, we want to requeue.


Kind regards,
Niklas

>  	}
> +
> +	return action;
>  }
>  
>  static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
