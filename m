From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/40] ipv6/flowlabel: simplify pid namespace
	lookup
Date: Tue, 15 May 2018 16:56:43 +0200
Message-ID: <20180515145643.GA661@lst.de>
References: <20180425154827.32251-1-hch@lst.de>
	<20180425154827.32251-12-hch@lst.de> <878t8y46sy.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <878t8y46sy.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-rtc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, megaraidlinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, May 05, 2018 at 07:37:33AM -0500, Eric W. Biederman wrote:
> Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:
> 
> > The shole seq_file sequence already operates under a single RCU lock pair,
> > so move the pid namespace lookup into it, and stop grabbing a reference
> > and remove all kinds of boilerplate code.
> 
> This is wrong.
> 
> Move task_active_pid_ns(current) from open to seq_start actually means
> that the results if you pass this proc file between callers the results
> will change.  So this breaks file descriptor passing.
> 
> Open is a bad place to access current.  In the middle of read/write is
> broken.
> 
> 
> In this particular instance looking up the pid namespace with
> task_active_pid_ns was a personal brain fart.  What the code should be
> doing (with an appropriate helper) is:
> 
> struct pid_namespace *pid_ns = inode->i_sb->s_fs_info;
> 
> Because each mount of proc is bound to a pid namespace.  Looking up the
> pid namespace from the super_block is a much better way to go.

What do you have in mind for the helper?  For now I've thrown it in
opencoded into my working tree, but I'd be glad to add a helper.

struct pid_namespace *proc_pid_namespace(struct inode *inode)
{
	// maybe warn on for s_magic not on procfs??
	return inode->i_sb->s_fs_info;
}

?
