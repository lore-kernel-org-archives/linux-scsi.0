From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Sat, 30 Apr 2016 18:54:20 +0300
Message-ID: <CAJ3xEMiyQaWwsgVd_J9eVXqPwPk6=VYN_iMoEJQGz=1wHFrHqQ@mail.gmail.com>
References: <cover.1461088672.git.varun@chelsio.com>
	<62c9d9c1e609c39f714ef15c10ba62b1cbbddecd.1461088673.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <62c9d9c1e609c39f714ef15c10ba62b1cbbddecd.1461088673.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, kxie@chelsio.com, indranil@chelsio.com, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 19, 2016 at 9:30 PM, Varun Prakash <varun@chelsio.com> wrote:
> cxgbit.h - This file contains data structure
> definitions for cxgbit.ko.
>
> cxgbit_lro.h - This file contains data structure
> definitions for LRO support.
>
> cxgbit_main.c - This file contains code for
> registering with iscsi target transport and
> cxgb4 driver.
>
> cxgbit_cm.c - This file contains code for
> connection management.
>
> cxgbit_target.c - This file contains code
> for processing iSCSI PDU.
>
> cxgbit_ddp.c - This file contains code for
> Direct Data Placement.

Wait,

You are adding many K's LOCs to handle things like CM (connection
management), DDP and LRO. But your upstream solution must be using CM
and DDP (and LRO as well) for the HW offloaded initiator side as well,
not to mention the iWARP side of things.

There must be some way to refactor things instead of repeating the
same bits over and over, thoughts?

Or.

>  drivers/target/iscsi/Kconfig                |    2 +
>  drivers/target/iscsi/Makefile               |    1 +
>  drivers/target/iscsi/cxgbit/Kconfig         |    7 +
>  drivers/target/iscsi/cxgbit/Makefile        |    6 +
>  drivers/target/iscsi/cxgbit/cxgbit.h        |  353 +++++
>  drivers/target/iscsi/cxgbit/cxgbit_cm.c     | 2086 +++++++++++++++++++++++++++
> drivers/target/iscsi/cxgbit/cxgbit_ddp.c    |  325 +++++
> drivers/target/iscsi/cxgbit/cxgbit_lro.h    |   72 +
> drivers/target/iscsi/cxgbit/cxgbit_main.c   |  701 +++++++++
>  drivers/target/iscsi/cxgbit/cxgbit_target.c | 1561 ++++++++++++++++++++
> 10 files changed, 5114 insertions(+)
