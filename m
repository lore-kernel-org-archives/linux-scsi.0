From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 2/9] target/pr: Use atomic bitop for
	se_dev_entry->pr_reg reservation check
Date: Fri, 22 May 2015 10:26:14 +0200
Message-ID: <20150522082614.GA24640@lst.de>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com> <1432275071-28882-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432275071-28882-3-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 22, 2015 at 06:11:04AM +0000, Nicholas A. Bellinger wrote:
> +	clear_bit(1, &orig->pr_reg);

Can you call it ->flags and give the bit a meaningful name?

> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index c0b593a..d29b39c 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -327,9 +327,13 @@ static int core_scsi3_pr_seq_non_holder(
>  	int we = 0; /* Write Exclusive */
>  	int legacy = 0; /* Act like a legacy device and return
>  			 * RESERVATION CONFLICT on some CDBs */
> +	bool registered = false;
>  
>  	rcu_read_lock();
>  	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
> +	if (se_deve)
> +		registered = test_bit(1, &se_deve->pr_reg);
> +	rcu_read_unlock();

It would be good to just sort out the registered and co variables
here before the RCU changes, as in:

http://git.infradead.org/users/hch/scsi.git/commitdiff/6372d9f62c83acb30d051387c40deb4dbdcaa376
