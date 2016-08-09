From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 9 Aug 2016 08:51:00 -0700
Message-ID: <2aaad6b7-bfa4-b965-53bf-4420fe01d3e5@sandisk.com>
References: <20160801175948.GA6685@redhat.com>
	<1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com>
	<73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com>
	<1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com>
	<SN1PR0201MB1870C587B123A8F84A49C1BD811B0@SN1PR0201MB1870.namprd02.prod.outlook.com>
	<551419047.135340.1470669997660.JavaMail.zimbra@redhat.com>
	<077d2708-3360-d8d7-fb3c-d3a73a1e03ee@sandisk.com>
	<1345038259.188657.1470696767844.JavaMail.zimbra@redhat.com>
	<1771573384.192110.1470701350622.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1771573384.192110.1470701350622.JavaMail.zimbra@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Laurence Oberman <loberman@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 08/08/2016 05:09 PM, Laurence Oberman wrote:
> So now back to a 10 LUN dual path (ramdisk backed) two-server
> configuration I am unable to reproduce the dm issue.
> Recovery is very fast with the servers connected back to back.
> This is using your kernel and this multipath.conf
> 
> [ ... ]
> 
> Mikes patches have definitely stabilized this issue for me on this
> configuration.
> 
> I will see if I can move to a larger target server that has more
> memory and allocate more mpath devices. I feel this issue in large
> configurations is now rooted in multipath not bringing back maps
> sometimes even when the actual paths are back via srp_daemon.
> I am still tracking that down.
> 
> If you recall, last week I caused some of our own issues by
> forgetting I had a no_path_retry 12 hiding in my multipath.conf.
> Since removing that and spending most of the weekend testing on
> the DDN array (had to give that back today), most of my issues
> were either the sporadic host delete race or multipath not
> re-instantiating paths.
> 
> I dont know if this helps, but since applying your latest patch I
> have not seen the host delete race.

Hello Laurence,

My latest SCSI core patch adds additional instrumentation to the SCSI
core but does not change the behavior of the SCSI core. So it cannot
fix the scsi_forget_host() crash you had reported.

On my setup, with the kernel code from the srp-initiator-for-next
branch and with CONFIG_DM_MQ_DEFAULT=n, I still see that when I run the
srp-test software that fio reports I/O errors every now and then. What
I see in syslog seems to indicate that these I/O errors are generated
by dm-mpath:

Aug  9 08:45:39 ion-dev-ib-ini kernel: mpath 254:1: queue_if_no_path 1 -> 0
Aug  9 08:45:39 ion-dev-ib-ini kernel: must_push_back: 107 callbacks suppressed
Aug  9 08:45:39 ion-dev-ib-ini kernel: device-mapper: multipath: must_push_back: queue_if_no_path=0 suspend_active=1 suspending=0
Aug  9 08:45:39 ion-dev-ib-ini kernel: __multipath_map(): (a) returning -5
Aug  9 08:45:39 ion-dev-ib-ini kernel: map_request(): clone_and_map_rq() returned -5
Aug  9 08:45:39 ion-dev-ib-ini kernel: dm_complete_request: error = -5
Aug  9 08:45:39 ion-dev-ib-ini kernel: dm_softirq_done: dm-1 tio->error = -5

Bart.
