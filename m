From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: DM does not activate the paths if there are more
	than	one path in path group during failover
Date: Tue, 11 Nov 2008 10:13:11 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BE75B7F@cosmail01.lsi.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
	<20081111005920.GN16649@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081111005920.GN16649@agk.fab.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
Cc: "andmike@linux.vnet.ibm.com" <andmike@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Thanks for the response.

If pg_init is intended to be called only once then problem is elsewhere.

During the pg_init, the activate_path is called. The activate_path calls =
scsi_dh_activate(then rdac_activate) which will set path state to active(=
h->state =3D RDAC_STATE_ACTIVE;). My understanding is, h->state is specif=
ic to each path. How does d-m sets h->state to RDAC_STATE_ACTIVE for all =
the paths available in the path group.

This is what happening in my case. On path group failure, d-m switches th=
e path group initiates path group. It then selects the first path (in the=
 path group) starts I/O. After exhausting the repeat_count it then select=
s the next path in the path group.  Then rdac_prep_fn is called. This fun=
ction finds h->state is still passive and fails the path which becomes un=
usable.

This function returns BLKPREP_KILL which is leading to fail failure.

static int rdac_prep_fn(struct scsi_device *sdev, struct request *req)
{
        struct rdac_dh_data *h =3D get_rdac_data(sdev);
        int ret =3D BLKPREP_OK;

        if (h->state !=3D RDAC_STATE_ACTIVE) {
                ret =3D BLKPREP_KILL;
                req->cmd_flags |=3D REQ_QUIET;
        }
        return ret;
}

This is my understanding so far. Please correct me if there is anything w=
rong.


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Alasdair G Kergon
Sent: Monday, November 10, 2008 6:59 PM
To: device-mapper development
Cc: andmike@linux.vnet.ibm.com; linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] DM does not activate the paths if there are more =
than one path in path group during failover

pg_init is a function intended to be called *once* when there is a switch=
 to a new group of paths.  It is not per-path initialisation.

Alasdair
--
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
