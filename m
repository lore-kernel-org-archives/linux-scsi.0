From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [Lsf-pc] [LFS/MM TOPIC][LFS/MM ATTEND]: - Storage Stack and
 Driver Testing methodology.
Date: Thu, 12 Jan 2017 13:01:35 +0200
Message-ID: <74f07f96-4741-1bbc-d570-1aea0a31b41e@grimberg.me>
References: <CO2PR04MB218427BF42159B20FB26F74186670@CO2PR04MB2184.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CO2PR04MB218427BF42159B20FB26F74186670@CO2PR04MB2184.namprd04.prod.outlook.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> Hi Folks,
>
> I would like to propose a general discussion on Storage stack and device driver testing.

I think its very useful and needed.

> Purpose:-
> -------------
> The main objective of this discussion is to address the need for
> a Unified Test Automation Framework which can be used by different subsystems
> in the kernel in order to improve the overall development and stability
> of the storage stack.
>
> For Example:-
> From my previous experience, I've worked on the NVMe driver testing last year and we
> have developed simple unit test framework
>  (https://github.com/linux-nvme/nvme-cli/tree/master/tests).
> In current implementation Upstream NVMe Driver supports following subsystems:-
> 1. PCI Host.
> 2. RDMA Target.
> 3. Fiber Channel Target (in progress).
> Today due to lack of centralized automated test framework NVMe Driver testing is
> scattered and performed using the combination of various utilities like nvme-cli/tests,
> nvmet-cli, shell scripts (git://git.infradead.org/nvme-fabrics.git nvmf-selftests) etc.
>
> In order to improve overall driver stability with various subsystems, it will be beneficial
> to have a Unified Test Automation Framework (UTAF) which will centralize overall
> testing.
>
> This topic will allow developers from various subsystem engage in the discussion about
> how to collaborate efficiently instead of having discussions on lengthy email threads.

While a unified test framework for all sounds great, I suspect that the
difference might be too large. So I think that for this framework to be
maintainable, it needs to be carefully designed such that we don't have
too much code churn.

For example we should start by classifying tests and then see where
sharing is feasible:

1. basic management - I think not a lot can be shared
2. spec compliance - again, not much sharing here
3. data-verification - probably everything can be shared
4. basic performance - probably a lot can be shared
5. vectored-io - probably everything can be shared
6. error handling - I can think of some sharing that can be used.

This repository can also store some useful tracing scripts (ebpf and
friends) that are useful for performance analysis.

So I think that for this to happen, we can start with the shared
test under block/, then migrate proto specific tests into
scsi/, nvme/, and then add transport specific tests so
we can have something like:

├── block
├── lib
├── nvme
│   ├── fabrics
│   │   ├── loop
│   │   └── rdma
│   └── pci
└── scsi
     ├── fc
     └── iscsi

Thoughts?
