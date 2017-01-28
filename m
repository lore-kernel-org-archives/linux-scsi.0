From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 15/18] scsi: allocate scsi_cmnd structures as
	part of	struct request
Date: Sat, 28 Jan 2017 09:25:13 +0100
Message-ID: <20170128082513.GB4728@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-16-git-send-email-hch@lst.de>
	<1485542367.4267.19.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1485542367.4267.19.camel@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 27, 2017 at 06:39:46PM +0000, Bart Van Assche wrote:
> Why=A0have the=A0scsi_release_buffers() and scsi_put_command(cmd) calls b=
een
> moved up? I haven't found an explanation for this change in the patch
> description.

Because they reference the scsi_cmnd, which are now part of the request
and thus freed by blk_finish_request.  And yes, I should have mentioned
it in the changelog, sorry.

> Please also consider to remove the cmd->request->special =3D NULL assignm=
ents
> via this patch. Since this patch makes the lifetime of struct scsi_cmnd a=
nd
> struct request identical these assignments are no longer needed.

True.  If I had to resend again I would have fixed it up, but it's probably
not worth the churn now.

> This patch introduces the function scsi_exit_rq(). Having two functions
> for the single-queue path that release resources (scsi_release_buffers()
> and scsi_exit_rq()) is confusing. Since every scsi_release_buffers() call
> is followed by a blk_unprep_request() call, have you considered to move
> the scsi_release_buffers() call into scsi_unprep_fn() via an additional
> patch?

We could have done that.  But it's just more change for a code path
that I hope won't survive this calendar year.
