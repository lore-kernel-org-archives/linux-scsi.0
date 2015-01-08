From: Paul Koning <paulkoning-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Thu, 8 Jan 2015 10:57:42 -0500
Message-ID: <594465E8-4DBB-40AD-BA62-880A364F24A3@comcast.net>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <54AE8A02.1030100@dev.mellanox.co.il> <54AE9010.5080609@acm.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBDUOZNUSUMARBN6SXKSQKGQEHGKQW4I-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <54AE9010.5080609-HInyCGIudOg@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


> On Jan 8, 2015, at 9:11 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>=20
> On 01/08/15 14:45, Sagi Grimberg wrote:
>> Actually I started with that approach, but the independent connections
>> under a single session (I-T-Nexus) violates the command ordering
>> requirement. Plus, such a solution is specific to iSER=E2=80=A6

The iSCSI standard specifies an ordering requirement for the case of multip=
le connections under a single session.  That requirement is in fact a reaso=
n why some iSCSI targets have declined to implement multiple connections.

On the other hand, there are lots of =E2=80=9CMPIO=E2=80=9D implementations=
 in many different operating systems that use multiple sessions, so there i=
s no ordering at the iSCSI level, and whatever ordering is required (if any=
) is instead implemented at higher layers in the requesting OS.

>=20
> Hello Sagi,
>=20
> Which command ordering requirement are you referring to ? The Linux stora=
ge stack does not guarantee that block layer or SCSI commands will be proce=
ssed in the same order as these commands have been submitted.

Neither does SCSI, in fact.  The ordering rules of the SCSI standard are wo=
rth studying.  They are a lot weaker than most people expect.  A particular=
ly interesting case is multiple concurrent writes with overlapping block ra=
nges.

	paul

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
