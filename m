From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 11/40] ipv6/flowlabel: simplify pid namespace lookup
Date: Sat, 05 May 2018 07:37:33 -0500
Message-ID: <878t8y46sy.fsf@xmission.com>
References: <20180425154827.32251-1-hch@lst.de>
        <20180425154827.32251-12-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180425154827.32251-12-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 25 Apr 2018 17:47:58 +0200")
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> The shole seq_file sequence already operates under a single RCU lock pair,
> so move the pid namespace lookup into it, and stop grabbing a reference
> and remove all kinds of boilerplate code.

This is wrong.

Move task_active_pid_ns(current) from open to seq_start actually means
that the results if you pass this proc file between callers the results
will change.  So this breaks file descriptor passing.

Open is a bad place to access current.  In the middle of read/write is
broken.


In this particular instance looking up the pid namespace with
task_active_pid_ns was a personal brain fart.  What the code should be
doing (with an appropriate helper) is:

struct pid_namespace *pid_ns = inode->i_sb->s_fs_info;

Because each mount of proc is bound to a pid namespace.  Looking up the
pid namespace from the super_block is a much better way to go.

Eric



> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  net/ipv6/ip6_flowlabel.c | 28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
>
> diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
> index c05c4e82a7ca..a9f221d45ef9 100644
> --- a/net/ipv6/ip6_flowlabel.c
> +++ b/net/ipv6/ip6_flowlabel.c
> @@ -754,7 +754,10 @@ static struct ip6_flowlabel *ip6fl_get_idx(struct seq_file *seq, loff_t pos)
>  static void *ip6fl_seq_start(struct seq_file *seq, loff_t *pos)
>  	__acquires(RCU)
>  {
> +	struct ip6fl_iter_state *state = ip6fl_seq_private(seq);
> +
>  	rcu_read_lock_bh();
> +	state->pid_ns = task_active_pid_ns(current);
>  	return *pos ? ip6fl_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
>  }
>  
> @@ -810,36 +813,15 @@ static const struct seq_operations ip6fl_seq_ops = {
>  
>  static int ip6fl_seq_open(struct inode *inode, struct file *file)
>  {
> -	struct seq_file *seq;
> -	struct ip6fl_iter_state *state;
> -	int err;
> -
> -	err = seq_open_net(inode, file, &ip6fl_seq_ops,
> +	return seq_open_net(inode, file, &ip6fl_seq_ops,
>  			   sizeof(struct ip6fl_iter_state));
> -
> -	if (!err) {
> -		seq = file->private_data;
> -		state = ip6fl_seq_private(seq);
> -		rcu_read_lock();
> -		state->pid_ns = get_pid_ns(task_active_pid_ns(current));
> -		rcu_read_unlock();
> -	}
> -	return err;
> -}
> -
> -static int ip6fl_seq_release(struct inode *inode, struct file *file)
> -{
> -	struct seq_file *seq = file->private_data;
> -	struct ip6fl_iter_state *state = ip6fl_seq_private(seq);
> -	put_pid_ns(state->pid_ns);
> -	return seq_release_net(inode, file);
>  }
>  
>  static const struct file_operations ip6fl_seq_fops = {
>  	.open		=	ip6fl_seq_open,
>  	.read		=	seq_read,
>  	.llseek		=	seq_lseek,
> -	.release	=	ip6fl_seq_release,
> +	.release	=	seq_release_net,
>  };
>  
>  static int __net_init ip6_flowlabel_proc_init(struct net *net)
