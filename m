From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes + tcm_qla2xxx
 fabric module
Date: Tue, 15 May 2012 14:21:57 +0000
Message-ID: <4FB26685.4050200@acm.org>
References: <4FAFD976.8090409@acm.org>  <1336966168.25759.293.camel@haakon2.linux-iscsi.org>  <4FB0FF99.8060307@acm.org> <1337037165.25759.393.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1337037165.25759.393.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, James Bottomley <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 05/14/12 23:12, Nicholas A. Bellinger wrote:

> On Mon, 2012-05-14 at 12:50 +0000, Bart Van Assche wrote:
>> Note: in the kernel module with the shared code an interface will have
>> to be added that allows the initiator and the target module to enumerate
>> qla2xxx HBA ports. Maybe it's a good idea to add an interface similar to
>> the add_one() / remove_one() callback functions present in the Linux
>> InfiniBand stack.
> 
> Considering the time scales involved with doing this type of testing
> (esp the latter, which can take months) plus given the amount of LLD
> code involved (40K LOC), a large re-org that effects existing FC
> initiator mode operation is something we'd like to avoid for now.


Let me summarize what I've noticed after I had a (very) short look at
the proposed qla2xxx driver changes:
- The proposed changes do not allow to enable initiator and target mode
  simultaneously on a single FC port.
- Most of the initiator-mode SCSI host sysfs attributes are relevant in
  target mode too (e.g. NV-RAM access) and hence should be moved from
  the SCSI host to somewhere else. A good example is e.g. the Linux IB
  stack - in the IB stack there is a clean separation between
  HCA-specific sysfs attributes and sysfs attributes associated with
  higher-level services.
- The posted patch does not allow to add more FC functionality in a
  clean way, e.g. IP over FC or FC-VI. (Note: IP over FC has been
  standardized through RFC 4338 - http://tools.ietf.org/html/rfc4338.)

So I'm not sure whether the proposed approach is acceptable for a
mainline kernel driver. However, I'm not a SCSI maintainer and hence I
do not have a decisive voice in this matter.

Bart.
