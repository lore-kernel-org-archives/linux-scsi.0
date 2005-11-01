From: Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH/RFC] IB: Add SCSI RDMA Protocol (SRP)
	initiator
Date: Mon, 31 Oct 2005 20:55:23 -0800
Message-ID: <52irvdge6c.fsf@cisco.com>
References: <52wtjtk3d1.fsf@cisco.com>
	<20051101110409V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <openib-general-bounces@openib.org>
In-Reply-To: <20051101110409V.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Tue, 01 Nov 2005 11:04:09 +0900")
List-Unsubscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=unsubscribe>
List-Archive: <http://openib.org/pipermail/openib-general>
List-Post: <mailto:openib-general@openib.org>
List-Help: <mailto:openib-general-request@openib.org?subject=help>
List-Subscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=subscribe>
Sender: openib-general-bounces@openib.org
Errors-To: openib-general-bounces@openib.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

    FUJITA> Any reason the existing SRP definitions
    FUJITA> (drivers/scsi/ibmvscsi/srp.h) doesn't work for you?

Wow ... I never realized that ibmvscsi was an SRP initiator as well.

Anyway, looking at drivers/scsi/ibmvscsi/srp.h, the main problem I see
is that the file has a bunch of bitfields that are big-endian only
(which makes sense because the driver can only be compiled for pSeries
or iSeries anyway).

But I have no objection to moving the file to include/scsi/srp.h,
adding a bunch of

    #if defined(__LITTLE_ENDIAN_BITFIELD)
    #elif defined(__BIG_ENDIAN_BITFIELD)
    #endif

and adding a few missing defines, and then converting ib_srp to use
the same file.

Does that seem like the right thing to do?

Thanks,
  Roland
