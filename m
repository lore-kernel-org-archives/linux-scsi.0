From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: iscsi_trx going into D state
Date: Tue, 18 Oct 2016 23:25:59 -0700
Message-ID: <1476858359.8490.97.camel@haakon3.risingtidesystems.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
         <880e374c-cf8b-f276-e930-57b09fe1a686@suse.com>
         <CAANLjFobXiBO2tXxTBB-8BQjM8FC0wmxdxQvEd6Rp=1LZkrvpA@mail.gmail.com>
         <CAANLjFoh+C8QE=qcPKqUUG3SnH2EMmS7DWZ5D4AD7yWMxoK0Zw@mail.gmail.com>
         <4fc72e32-26fb-96bd-8a0d-814eef712b43@suse.com>
         <CAANLjFpx1MRNiu2388pY+U0O5z9gw+OJBtpOof47Lb_DxaJSBQ@mail.gmail.com>
         <1476774332.8490.43.camel@haakon3.risingtidesystems.com>
         <CAANLjFqXt5r=c9F75vjeK=_zLa8zCS1priLuZo=A1ZSHKZ=1Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFqXt5r=c9F75vjeK=_zLa8zCS1priLuZo=A1ZSHKZ=1Bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: Zhu Lingshan <lszhu-IBi9RG/b67k@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-10-18 at 16:13 -0600, Robert LeBlanc wrote:
> Nicholas,
> 
> We patched this in and for the first time in many reboots, we didn't
> have iSCSI going straight into D state. We have had to work on a
> couple of other things, so we don't know if this is just a coincidence
> or not. We will reboot back into the old kernel and back a few times
> and do some more testing, but so far it has given us a little bit of
> hope that we may be narrowing down on the root cause. We will report
> back once we have some more info.
> 
> Thank you,
> Robert LeBlanc
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> 

Hello Robert,

Thanks for the update.  Btw, if the original /var/log/messages
reproduction logs for iser-target are still handy, I'm happy to have
a look to confirm.  Feel free to send them along here, or off-list if
necessary.

For further reference, you can also enable Linux kernel crash dump
(LKCD) at build time using CONFIG_CRASH_DUMP=y, so it's possible to
manually generate a vmcore dumpfile of the running system via 'echo c
> /proc/sysrq-trigger', once the bug occurs.

http://cateee.net/lkddb/web-lkddb/CRASH_DUMP.html

Note in order to fully debug within this in a LKCD environment, it
requires the vmcore dump from /var/crash/, unstripped vmlinux,
target_core_mod, iscsi_target_mod and ib_isert modules matching the
specific particular x86_64 build setup of the running system.

Also, can you share a bit more about the details of your particular
iser-target + backend setup..?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
