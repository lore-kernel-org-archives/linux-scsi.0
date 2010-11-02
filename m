From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Full hostlock pushdown available
Date: Tue, 02 Nov 2010 14:13:20 -0400
Message-ID: <4CD054C0.4010309@garzik.org>
References: <20101028150508.GA2385@basil.fritz.box> <4CCD5F7F.8020808@panasas.com> <tkrat.c4793af298337eff@s5r6.in-berlin.de> <4CCE271D.7040400@garzik.org> <20101101135338.GA25817@basil.fritz.box> <4CCEE33F.5030300@garzik.org> <20101101175742.GG25817@basil.fritz.box> <4CCF0DFE.4050106@garzik.org> <20101102092111.GK25817@basil.fritz.box> <4CD03578.3050801@garzik.org> <20101102175336.GA2167@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20101102175336.GA2167@basil.fritz.box>
Sender: linux-ide-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/02/2010 01:53 PM, Andi Kleen wrote:
>> Boaz' approach is OBVIOUSLY mechanical, correct and bisectable.
>> Yours is not.
>
> Sorry Jeff, but my patch has 100% the same locking order as Boaz.
> The only difference is in which function it is.

Incorrect.  Please re-read your own code.

Your code eliminates the drop+reacquire of the host_lock, choosing 
instead a brand new, untested, unreviewing locking scheme of holding the 
host_lock for the entirety of libata's queuecommand run.

In contrast, Boaz' proposed pattern of adding stub functions such as

	int queuecmd_unlocked(scsi_cmd cmd, callback done)
	{
		lock_irqsave
		get serial

		call driver's existing queuecommand

		unlock_irqrestore
	}

does not change libata's locking at all, because it does not modify a 
driver's queuecommand at all.  It is obviously correct.

Or to restate another way,

	Current libata locking
	----------------------
	spin_lock_irqsave(host_lock)
	spin_unlock(host_lock)
	spin_lock(ap lock)
	...
	spin_unlock(ap lock)
	spin_lock(host_lock)
	spin_unlock_irqrestore(host_lock)


	Andi's brand new locking scheme
	(missing the release of host lock)
	----------------------------------
	spin_lock_irqsave(host_lock)
	spin_lock(ap lock)
	...
	spin_unlock(ap lock)
	spin_unlock_irqrestore(host_lock)

The two versions are quite obviously NOT equivalent in any way, because 
you have ADDED the holding of host_lock for the duration of libata's 
queuecommand.

	Jeff



