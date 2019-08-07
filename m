From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2] lpfc: Mitigate high memory pre-allocation by SCSI-MQ
Date: Wed, 7 Aug 2019 09:39:29 +0800
Message-ID: <CACVXFVM7sdY_rHZCsi3uTkyOme4rmNERk41754kW-yjNFN4FXQ@mail.gmail.com>
References: <20190801220941.19615-1-jsmart2021@gmail.com> <CACVXFVO7vmGJj_N_MT7roZDmWNHbEGR=MsOqkpb7NTptF3=DOw@mail.gmail.com>
 <227b2bc2-9778-6d38-a68b-26a799a0caeb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <227b2bc2-9778-6d38-a68b-26a799a0caeb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 7, 2019 at 1:13 AM James Smart <jsmart2021@gmail.com> wrote:
>
> On 8/5/2019 6:09 PM, Ming Lei wrote:
> >
> > I am wondering why you use 2 * num_possible_nodes() as the limit instead of
> > num_possible_nodes(), could you explain it a bit?
>
> The number comes from most systems being dual socket systems, thus a
> numa node count of 2. Some of these dual socket systems can be high cpu
> counts per socket. We did see a difference, on different architectures
> and where cpu counts were high per socket, that more hwqs per socket did
> help. So if there can be more than 1 hwq per socket then I think that is
> goodness.

I guess it isn't related with CPU cores per socket, what matters is number of
sockets, given each CPU core in same socket is in same position wrt. RW
preformance on same shared memory, so looks the following way is what
we need:

 shost->nr_hw_queues = max_t(int,  num_possible_nodes(),
                                          nr_processor_sockets);

However, I don't know how to retrieve 'nr_processor_sockets' in kernel.
Maybe topology_max_packages() can be used for x86, not see how to
read it for other ARCHs.

Cc Thomas and linux-kernel list.

Thanks,
Ming Lei
