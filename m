From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 02/16] device-dax: fix cdev leak
Date: Sun, 26 Feb 2017 10:22:36 -0800
Message-ID: <CAPcyv4hkirsNhx14HhiF6d7qmjtY7YD6ZjiyeLMw8C=QGpq0VA@mail.gmail.com>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-3-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1488091097-12328-3-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alexandre Bounine <alexandre.bounine-49Rm3DX9dRQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Peter Meerwald-Stadler <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Marek
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 25, 2017 at 10:38 PM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
> From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> If device_add() fails, cleanup the cdev. Otherwise, we leak a kobj_map()
> with a stale device number.
>
> As Jason points out, there is a small possibility that userspace has
> opened and mapped the device in the time between cdev_add() and the
> device_add() failure. We need a new kill_dax_dev() helper to invalidate
> any established mappings.
>
> Fixes: ba09c01d2fa8 ("dax: convert to the cdev api")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Reported-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Since you are forwarding this patch you should add

"Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>"
