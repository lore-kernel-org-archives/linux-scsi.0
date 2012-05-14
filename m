From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes + tcm_qla2xxx
 fabric module
Date: Mon, 14 May 2012 12:50:33 +0000
Message-ID: <4FB0FF99.8060307@acm.org>
References: <4FAFD976.8090409@acm.org> <1336966168.25759.293.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1336966168.25759.293.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, James Bottomley <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 05/14/12 03:29, Nicholas A. Bellinger wrote:

> That would probably work, but I think it's still just a band-aid on the
> underlying issue of SCSI LLDs always kicking off initiator mode enable /
> disable operations from within PCI *_probe_one() / *_remove_code() code.


Maybe the following makes sense (I'm not familiar with the qla2xxx
driver nor with FC): split the qla2xxx driver in three kernel modules -
a kernel module with the code that is shared by initiator and target
mode, a kernel module with the initiator functionality and a kernel
module with the target functionality. This will allow users to choose
which functionality to enable by loading the proper kernel module(s).
Note: in the kernel module with the shared code an interface will have
to be added that allows the initiator and the target module to enumerate
qla2xxx HBA ports. Maybe it's a good idea to add an interface similar to
the add_one() / remove_one() callback functions present in the Linux
InfiniBand stack.

Bart.
