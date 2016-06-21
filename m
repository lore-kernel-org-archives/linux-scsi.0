From: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Tue, 21 Jun 2016 16:08:58 +0300
Message-ID: <57693C6A.3020805@gmail.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
 <5756B7D2.5040009@mellanox.com>
 <CAANLjFq4CoOSbng=aPHiSsFB=1HMSwAhhLiCjt+88dzz24OT9w@mail.gmail.com>
 <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow@mail.gmail.com>
 <57582336.10407@mellanox.com>
 <CAANLjFrLK-ZVP5XX3TnkAMz+7_pd6qc+c88mbF4vF9DQ+F5U=A@mail.gmail.com>
 <CAANLjFrv-0VArTEkgqbrhzFjn1fg_egpCJuQZnAurVrHjbL_qA@mail.gmail.com>
 <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hey Robert,

> I narrowed the performance degradation to this series
> 7861728..5e47f19, but while trying to bisect it, the changes were
> erratic between each commit that I could not figure out exactly which
> introduced the issue. If someone could give me some pointers on what
> to do, I can keep trying to dig through this.

This bisection brings suspects:

e3416ab2d156 iser-target: Kill the ->isert_cmd back pointer in struct 
iser_tx_desc
d1ca2ed7dcf8 iser-target: Kill struct isert_rdma_wr
9679cc51eb13 iser-target: Convert to new CQ API
5adabdd122e4 iser-target: Split and properly type the login buffer
ed1083b251f0 iser-target: Remove ISER_RECV_DATA_SEG_LEN
26c7b673db57 iser-target: Remove impossible condition from isert_wait_conn
69c48846f1c7 iser-target: Remove redundant wait in release_conn
6d1fba0c2cc7 iser-target: Rework connection termination
f81bf458208e iser-target: Separate flows for np listeners and 
connections cma events
aea92980601f iser-target: Add new state ISER_CONN_BOUND to isert_conn
b89a7c25462b iser-target: Fix identification of login rx descriptor type

However I don't really see performance implications in these patches,
not to mention something that would affect on ConnectIB...

Given that your bisection brings up target side patches, I have
a couple questions:

1. Are the CPU usage in the target side at 100%, or the initiator side
is the bottleneck?

2. Would it be possible to use another target implementation? TGT maybe?

3. Can you try testing right before 9679cc51eb13? This is a patch that
involves data-plane.

4. Can you try the latest upstream kernel? The iser target code uses
a generic data-transfer library and I'm interested in knowing what is
the status there.

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
