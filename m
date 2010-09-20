From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [RFC 15/22] tcm: Add FILEIO subsystem plugin
Date: Mon, 20 Sep 2010 18:18:21 +0200
Message-ID: <AANLkTimPh+SNroYoavomwVtQ5UHsr7Lsq_229Vkbc1CB@mail.gmail.com>
References: <1283160144-6848-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1283160144-6848-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 30, 2010 at 11:22 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds the O_SYNC FILEIO subsystem plugin for accessing stru=
ct file
> using Linux/VFS struct file_operations. =A0It also includes WriteCach=
e and FUA
> Write Emulation support to struct file using fs/sync.c/vfs_fsync_rang=
e()
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
>
> [ ... ]
>
> +static int fd_do_writev(struct fd_request *req, struct se_task *task=
)
> +{
> + =A0 =A0 =A0 struct file *fd =3D req->fd_dev->fd_file;
> + =A0 =A0 =A0 struct scatterlist *sg =3D task->task_sg;
> + =A0 =A0 =A0 struct iovec iov[req->fd_sg_count];

Kernel stack size is 8 KB. On a 64-bit system struct iovec takes 16
bytes. What happens if req->fd_sg_count is large ? Kernel crash ?

=46ubo.
