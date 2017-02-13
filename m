From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [bug report] scsi: aacraid: Added support for hotplug
Date: Mon, 13 Feb 2017 19:39:15 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8BD440@avsrvexchmbx2.microsemi.net>
References: <20170213184707.GA19576@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0041.outbound.protection.outlook.com ([104.47.36.41]:61056
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751313AbdBMTjW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 14:39:22 -0500
In-Reply-To: <20170213184707.GA19576@mwanda>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Don,

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, February 13, 2017 10:47 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: linux-scsi@vger.kernel.org
> Subject: [bug report] scsi: aacraid: Added support for hotplug
>=20
> EXTERNAL EMAIL
>=20
>=20
> Hello Raghava Aditya Renukunta,
>=20
> The patch 6223a39fe6fb: "scsi: aacraid: Added support for hotplug"
> from Feb 2, 2017, leads to the following static checker warning:
>=20
>         drivers/scsi/aacraid/commsup.c:2243 aac_process_events()
>         error: double unlock 'spin_lock:t_lock'
>=20
> drivers/scsi/aacraid/commsup.c
>   2130          spin_lock_irqsave(t_lock, flags);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   2131
>   2132          while (!list_empty(&(dev->queues-
> >queue[HostNormCmdQueue].cmdq))) {
>   2133                  struct list_head *entry;
>   2134                  struct aac_aifcmd *aifcmd;
>   2135                  unsigned int  num;
>   2136                  struct hw_fib **hw_fib_pool, **hw_fib_p;
>   2137                  struct fib **fib_pool, **fib_p;
>   2138
>   2139                  set_current_state(TASK_RUNNING);
>   2140
>   2141                  entry =3D dev->queues-
> >queue[HostNormCmdQueue].cmdq.next;
>   2142                  list_del(entry);
>   2143
>   2144                  t_lock =3D dev->queues->queue[HostNormCmdQueue].l=
ock;
>   2145                  spin_unlock_irqrestore(t_lock, flags);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   2146
>   2147                  fib =3D list_entry(entry, struct fib, fiblink);
>   2148                  hw_fib =3D fib->hw_fib_va;
>   2149                  if (dev->sa_firmware) {
>   2150                          /* Thor AIF */
>   2151                          aac_handle_sa_aif(dev, fib);
>   2152                          aac_fib_adapter_complete(fib, (u16)sizeof=
(u32));
>   2153                          continue;
>=20
> The locking isn't right here.  We should re-take the spinlock before
> continuing.

The intention here is to protect the retrieval of entry from the queues.
Or do you mean that we should just protect the whole while loop with one sp=
in_lock (t_lock)?

Thank you,
Raghava Aditya

>   2154                  }
>   2155                  /*
>   2156                   *      We will process the FIB here or pass it t=
o a
>   2157                   *      worker thread that is TBD. We Really can'=
t
>   2158                   *      do anything at this point since we don't =
have
>   2159                   *      anything defined for this thread to do.
>   2160                   */
>=20
>         [ snip ]
>=20
>   2221  free_mem:
>   2222                  /* Free up the remaining resources */
>   2223                  hw_fib_p =3D hw_fib_pool;
>   2224                  fib_p =3D fib_pool;
>   2225                  while (hw_fib_p < &hw_fib_pool[num]) {
>   2226                          kfree(*hw_fib_p);
>   2227                          kfree(*fib_p);
>   2228                          ++fib_p;
>   2229                          ++hw_fib_p;
>   2230                  }
>   2231                  kfree(fib_pool);
>   2232  free_hw_fib_pool:
>   2233                  kfree(hw_fib_pool);
>   2234  free_fib:
>   2235                  kfree(fib);
>   2236                  t_lock =3D dev->queues->queue[HostNormCmdQueue].l=
ock;
>   2237                  spin_lock_irqsave(t_lock, flags);
>   2238          }
>   2239          /*
>   2240           *      There are no more AIF's
>   2241           */
>   2242          t_lock =3D dev->queues->queue[HostNormCmdQueue].lock;
>   2243          spin_unlock_irqrestore(t_lock, flags);
>=20
> Otherwise it is a double unlock bug.
>=20
>   2244  }
>=20
>=20
> regards,
> dan carpenter
