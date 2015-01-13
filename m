From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Tue, 13 Jan 2015 11:46:44 +0200
Message-ID: <54B4E984.5000106@dev.mellanox.co.il>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <1420755361.2842.16.camel@haakon3.risingtidesystems.com> <1420756142.11310.9.camel@HansenPartnership.com> <1420757822.2842.39.camel@haakon3.risingtidesystems.com> <1420759360.11310.13.camel@HansenPartnership.com> <1420779808.21830.21.camel@haakon3.risingtidesystems.com> <38CE4ECA-D155-4BF9-9D6D-E1A01ADA05E4@cs.wisc.edu> <54B01DBD.5020707@suse.de> <54B037BF.1010903@cs.wisc.edu> <54B24501.7090801@dev.mellanox.co.il> <54B3C47E.6010109@sandisk.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Return-path: <open-iscsi+bncBCMYDBGM6EBBBC6T2OSQKGQEAX7MBCA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <54B3C47E.6010109-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 1/12/2015 2:56 PM, Bart Van Assche wrote:
> On 01/11/15 10:40, Sagi Grimberg wrote:
>> I would say there is no need for specific coordination from iSCSI PoV.
>> This is exactly what flow steering is designed for. As I see it, in
>> order to get the TX/RX to match rings, the user can attach 5-tuple rules
>> (using standard ethtool) to steer packets to the right rings.
>
> Hello Sagi,
>
> Can the 5-tuple rules be chosen such that it is guaranteed that the
> sockets used to implement per-CPU queues are spread evenly over MSI-X
> completion vectors ? If not, would it help to add a socket option to the
> Linux network stack that allows to select the TX ring explicitly, just
> like ib_create_cq() in the Linux RDMA stack allows to select a
> completion vector explicitly ? My concerns are as follows:
> - If the number of queues exceeds the number of MSI-X vectors then I
>    expect that it will be much easier to guarantee even spreading by
>    selecting tx queues explicitly instead of relying on a hashing scheme.
> - On multi-socket systems it is important to process completion
>    interrupts on the CPU socket from where the I/O was initiated. I'm
>    not sure it is possible to guarantee this when using a hashing
>    algorithm to select the TX ring.
>

Hey Bart,

Your concerns are correct. Flow steering rules will guarantee that each
socket will have a different TX/RX ring, but not necessarily the
"correct" TX/RX ring. These issues have been addressed in the
Networking subsystem.

Thinking more on this out loud,

There is the TX challenge, getting the HW queue selection to match the
TX ring selection (which might not be the same according to flow hash), 
First thing that comes to mind is XPS (Transmit Packet Steering).

 From Documentation/networking/scaling.txt:
"Transmit Packet Steering is a mechanism for intelligently selecting
which transmit queue to use when transmitting a packet on a multi-queue
device. To accomplish this, a mapping from CPU to hardware queue(s) is
recorded. The goal of this mapping is usually to assign queues
exclusively to a subset of CPUs, where the transmit completions for
these queues are processed on a CPU within this set."

About the RX challenge, I think RFS (Receive Flow Steering) will
probably be the best fit here since RX packets will be steered to the
CPU where the application is running.

 From Documentation/networking/scaling.txt:
"The goal of RFS is to increase datacache hitrate by steering
kernel processing of packets to the CPU where the application thread
consuming the packet is running. RFS relies on the same RPS mechanisms
to enqueue packets onto the backlog of another CPU and to wake up that
CPU. In RFS, packets are not forwarded directly by the value of their
hash, but the hash is used as index into a flow lookup table. This
table maps flows to the CPUs where those flows are being processed."

This definitely needs some more thinking. CC'ing Or Gerlitz which has
a lot of experience in the Networking stack...

Sagi.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
