From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Tue, 21 Jun 2016 08:50:04 -0600
Message-ID: <CAANLjFpUyAYB+ZzMwFKBpa4yLmALPzcRGJX1kExVrLARZmZRkA@mail.gmail.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
 <5756B7D2.5040009@mellanox.com> <CAANLjFq4CoOSbng=aPHiSsFB=1HMSwAhhLiCjt+88dzz24OT9w@mail.gmail.com>
 <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow@mail.gmail.com>
 <57582336.10407@mellanox.com> <CAANLjFrLK-ZVP5XX3TnkAMz+7_pd6qc+c88mbF4vF9DQ+F5U=A@mail.gmail.com>
 <CAANLjFrv-0VArTEkgqbrhzFjn1fg_egpCJuQZnAurVrHjbL_qA@mail.gmail.com>
 <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw@mail.gmail.com> <57693C6A.3020805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57693C6A.3020805-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Sagi,

I'm working to implement SRP (I think I got it all working) to test
some of the commits. I can try TGT afterwards and the commit you
mention. I haven't been watching the CPU lately, but before when I was
doing a lot of testing, there wasn't any one thread that was at 100%.
There are several threads that have high utilization, but none 100%
and there is plenty of CPU capacity available (32 cores). I can
capture some of that data if it is helpful. I did test 4.7_rc3 on
Friday, but it didn't change much, is that "new" enough?

4.7.0_rc3_5edb5649
sdc;10.218.128.17;3260244;815061;25730
sdg;10.218.202.17;3405988;851497;24629
sdh;10.218.203.17;3307419;826854;25363
sdm;10.218.204.17;3430502;857625;24453
sdi;10.219.128.17;3544282;886070;23668
sdj;10.219.202.17;3412083;853020;24585
sdk;10.219.203.17;3422385;855596;24511
sdl;10.219.204.17;3444164;861041;24356
sdb;10.220.128.17;4803646;1200911;17463
sdd;10.220.202.17;4832982;1208245;17357
sde;10.220.203.17;4809430;1202357;17442
sdf;10.220.204.17;4808878;1202219;17444

Thanks for the suggestions, I'll work to get some of the requested
data back to you guys quickly.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Tue, Jun 21, 2016 at 7:08 AM, Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hey Robert,
>
>> I narrowed the performance degradation to this series
>> 7861728..5e47f19, but while trying to bisect it, the changes were
>> erratic between each commit that I could not figure out exactly which
>> introduced the issue. If someone could give me some pointers on what
>> to do, I can keep trying to dig through this.
>
>
> This bisection brings suspects:
>
> e3416ab2d156 iser-target: Kill the ->isert_cmd back pointer in struct
> iser_tx_desc
> d1ca2ed7dcf8 iser-target: Kill struct isert_rdma_wr
> 9679cc51eb13 iser-target: Convert to new CQ API
> 5adabdd122e4 iser-target: Split and properly type the login buffer
> ed1083b251f0 iser-target: Remove ISER_RECV_DATA_SEG_LEN
> 26c7b673db57 iser-target: Remove impossible condition from isert_wait_conn
> 69c48846f1c7 iser-target: Remove redundant wait in release_conn
> 6d1fba0c2cc7 iser-target: Rework connection termination
> f81bf458208e iser-target: Separate flows for np listeners and connections
> cma events
> aea92980601f iser-target: Add new state ISER_CONN_BOUND to isert_conn
> b89a7c25462b iser-target: Fix identification of login rx descriptor type
>
> However I don't really see performance implications in these patches,
> not to mention something that would affect on ConnectIB...
>
> Given that your bisection brings up target side patches, I have
> a couple questions:
>
> 1. Are the CPU usage in the target side at 100%, or the initiator side
> is the bottleneck?
>
> 2. Would it be possible to use another target implementation? TGT maybe?
>
> 3. Can you try testing right before 9679cc51eb13? This is a patch that
> involves data-plane.
>
> 4. Can you try the latest upstream kernel? The iser target code uses
> a generic data-transfer library and I'm interested in knowing what is
> the status there.
>
> Cheers,
> Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
