From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] ib_srpt: Make srp_max_req_size module parameter
 use S_IRUGO|S_IWUSR
Date: Sun, 06 Nov 2011 04:10:00 -0800
Message-ID: <1320581400.5859.449.camel@haakon2.linux-iscsi.org>
References: <1320578141-27048-1-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-qEUcheRYWfiak1p=a01YZNX+ggQNT5phfDtOYtJZLmOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-qEUcheRYWfiak1p=a01YZNX+ggQNT5phfDtOYtJZLmOw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-11-06 at 12:46 +0100, Bart Van Assche wrote:
> On Sun, Nov 6, 2011 at 12:15 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This patch converts the srp_max_req_size module parameter to R/W access
> > so that it's accessable when built as CONFIG_INFINIBAND_SRPT=y.  This
> 
> accessible ?
> 
> > includes adding srpt_device->max_req_size that is assigned during
> > srpt_add_one() and referenced directly from there.
> 
> I'm not sure it makes sense to store a copy of this parameter in the
> srpt_device structure. If the HCA driver code (e.g. mlx4) is also
> built into the kernel instead of as a separate module, any changes of
> srp_max_req_size after ib_srpt and HCA driver initialization finished
> won't have any effect.
> 

So it sounds like srp_max_req_size with CONFIG_INFINIBAND_SRPT=y is not
really going to be of much use anyways.  What about just leaving it as
read-only..?

--nab
