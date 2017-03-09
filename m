From: Ilias Tsitsimpis <iliastsi@arrikto.com>
Subject: Re: [PATCH] target/user: Fix possible overwrite of t_data_sg's
 lastiov[]
Date: Thu, 9 Mar 2017 14:51:12 +0200
Message-ID: <20170309125112.a5xuyxl4acu3apga@iliastsi-m.arr>
References: <1488260828-28167-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <92ad7848-8d75-3344-eff6-b003599c55e9@redhat.com>
 <edee1773-74b5-d0e2-4b81-12cd75e55e52@cmss.chinamobile.com>
 <403e24b7-ecab-24e8-24cc-b9755b937c99@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <403e24b7-ecab-24e8-24cc-b9755b937c99@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Xiubo Li <lixiubo@cmss.chinamobile.com>
Cc: nab@linux-iscsi.org, shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, mchristi@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Andy, Xiubo,

On Fri, Mar 03, 2017 at 11:00AM, Andy Grover wrote:
> On 02/27/2017 09:47 PM, lixiubo@cmss.chinamobile.com wrote:
> > From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> > 
> > If there has BIDI data, its first iov[] will overwrite the last
> > iov[] for se_cmd->t_data_sg.
> 
> (+CCing orig BIDI and data block code authors)
> 
> Yeah. It looks like because alloc_and_scatter_data_area() (hereafter
> "aasda") is called twice in the BIDI case, and both times iov_cnt is 0, the
> new_iov() call doesn't increment the iov ptr and the first bidi iov
> overwrites the last data iov. Maybe fix this by exiting aasda() with iov
> pointing at the next unused iov in the array? Probably also want to zero the
> iov.

Yes this is definitely a bug, thanks for catching this. This seems to
have been introduced around the time new_iov() was introduced, and hence
it has been broken since v4.6.

On Mon, Mar 06, 2017 at 10:09AM, Andy Grover wrote:
> On 03/05/2017 09:48 PM, Xiubo Li wrote:
> > For the BIDI data, still hasn't been used by the tcmu-runner. Is any
> > other consumer using this?
> 
> Well with kernel APIs you just never know if somebody's using it but just
> not saying anything. But given this bug, how could they?

I added support for BIDI commands initially, as I needed to have SCSI
OSD working over tcmu and the OSD protocol requires BIDI support and I
am definitely using it now. Unfortunately, I haven't been able to
closely follow the development of target/user lately, so I failed to
notice this breakage in time. Sorry about that.

-- 
Ilias
