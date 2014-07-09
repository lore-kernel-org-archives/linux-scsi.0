From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the
 storage protocol version
Date: Wed, 9 Jul 2014 20:02:41 +0000
Message-ID: <c3b8b490725541afb2fb470a9e6d4348@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-2-git-send-email-kys@microsoft.com>
 <20140709084055.GB6012@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140709084055.GB6012@infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:41 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the
> storage protocol version
> 
> On Tue, Jul 08, 2014 at 05:46:46PM -0700, K. Y. Srinivasan wrote:
> > Going forward it is possible that some of the commands that are not
> > currently implemented will be implemented on future Windows hosts.
> > Make command filtering depend on the host version.
> 
> > +	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
> > +		/*
> > +		 * On legacy hosts filter unimplemented commands.
> > +		 */
> > +		if (!storvsc_scsi_cmd_ok(scmnd)) {
> > +			scmnd->scsi_done(scmnd);
> > +			return 0;
> > +		}
> 
> So post-Win8 versions don't need command filering as they can properly
> reject commands they don't understand?  If that's the case please state it in
> the patch description.

I will add the comments you have suggested.

K. Y
