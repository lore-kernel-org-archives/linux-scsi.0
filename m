From: "goggin, edward" <egoggin@emc.com>
Subject: RE: Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 17:02:44 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A922@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Lars Marowsky-Bree' <lmb@suse.de>, device-mapper development <dm-devel@redhat.com>, Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thursday, April 21, 2005 3:55 PM,  Lars Marowsky-Bree wrote:
> Together with the "queue_if_no_path" feature flag for dm-mpath that
> should do what you need to handle this (arguably broken) array
> behaviour: It'll queue until the error goes away and 
> multipathd retests
> and reactivates the paths. That ought to work, but given that I don't
> have an IBM ESS accessible, please confirm that.

Depending on the "queue_if_no_path" feature has the current undesirable
side-effect of requiring intervention of the user space multipath components
to reinstate at least one of the paths to a useable state in the multipath
target driver.  This dependency currently creates the potential for deadlock
scenarios since the user space multipath components (nor the kernel for that
matter) are currently architected to avoid them.

I think for now it may be better to try to avoid having to fail a path if it
is possible that an io error is not path related.
