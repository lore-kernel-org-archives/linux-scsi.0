From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH-v2] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Mon, 24 Oct 2011 14:01:37 -0700
Message-ID: <CAG4TOxMmB13exCOx_QC6+302sS4GjhggNrTwdLi4n14=as2PWQ@mail.gmail.com>
References: <1319435841-19046-1-git-send-email-nab@linux-iscsi.org>
 <CAO+b5-rch-mPgXKjs4=t4ubfb9SFhDiR26EoeJgyZjWfhRJ9DA@mail.gmail.com> <1319481232.17450.11.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1319481232.17450.11.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "\"Bart Van Assche" <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger\"" <nab@linux-iscsi.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Vu Pham <vu@mellanox.com>, David Dillow <dillowda@ornl.gov>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 24, 2011 at 11:33 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>> - Handle IB completion timeouts. Although the InfiniBand Architecture
>> Manual specifies that a HCA must generate an error completion for each
>> pending work item when a queue pair reset is issued, an important
>> class of HCAs doesn't do this (that includes the HCA in your test
>> setup). In the SCST version of this driver such timeouts are handled
>> by the function srpt_pending_cmd_timeout().

Hold on... not sure what you mean by a "queue pair reset" but the IB
spec does not say that a flush error should be generated when a QP is
transitioned to the "reset" state.  The flush error completions are
required when a QP is transitioned to the "error" state, and in fact
completion entries may be lost when a QP transitions to "reset".

As far as I know every HCA supported by Linux does implement this
correctly.  Which class did you have in mind as not doing that?

 - R.
