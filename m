From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 01/14] chardev: add helper function to register char devs
 with a struct device
Date: Tue, 21 Feb 2017 16:41:01 -0700
Message-ID: <0f24273d-028c-9fa3-3fe7-975d2b0540f8@deltatee.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-2-git-send-email-logang@deltatee.com>
 <20170221053522.GA1466@dtor-ws>
 <17f32963-1d0e-5d17-64c9-742b05415722@deltatee.com>
 <CAPcyv4jOWDxjQoBdZ8GQ+yhcAcL2gOBoEEHE-02beopXKFmGQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4jOWDxjQoBdZ8GQ+yhcAcL2gOBoEEHE-02beopXKFmGQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alexandre Bounine <alexandre.bounine-49Rm3DX9dRQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Peter Meerwald-Stadler <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Marek
List-Id: linux-scsi@vger.kernel.org

Hey,

Ok, I'll do a v2 later this week with some of the feedback and tags?

Logan

On 21/02/17 11:18 AM, Dan Williams wrote:
> On Mon, Feb 20, 2017 at 10:35 PM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
>>
>>
>> On 20/02/17 10:35 PM, Dmitry Torokhov wrote:
>>> My only objection is to this statement. There is absolutely nothing that
>>> prevents from calling device_unregister() first and cdev_del() later.
>>> Refcounting will sort it all out.
>>
>> Yeah, I was really trying to warn people against calling cdev_del within
>> the release function of the device. If you do that, then the cdev
>> reference will block the device from ever getting released.
>>
>> Certainly, you could call device_unregister followed by cdev_del. I
>> could reword this if you feel it necessary.
> 
> I agree with Dmitry, just delete the statement in parenthesis and the
> rest is fine. If you're modifying this patch it might be good to take
> the opportunity to add a WARN_ON(!parent->kobj.state_initialized) to
> catch attempts to call device_add_cdev() with an uninitialized device.
> 
> You can also add:
> 
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
