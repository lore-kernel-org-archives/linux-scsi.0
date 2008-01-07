From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Mon, 07 Jan 2008 14:23:33 +0100
Message-ID: <478227D5.8050402@s5r6.in-berlin.de>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	<20080107020944.GA3637@darkstar.te-china.tietoenator.com>
	<20080107084528.GA8365@suse.de>
	<200801070101.15168.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200801070101.15168.david-b@pacbell.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: David Brownell <david-b@pacbell.net>
Cc: a.zummo@towertech.it, dbrownell@users.sourceforge.net, Dave Young <hidave.darkstar@gmail.com>, linux-scsi@vger.kernel.org, cbou@mail.ru, peterz@infradead.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

David Brownell wrote:
> On Monday 07 January 2008, Greg KH wrote:
>> Most of the non-driver core code should be converted to not use the
>> lock in the class at all.  They should use a local lock instead.
> =

> Or better yet, that yet-to-be-written class_for_each_instance()
> iterator ... :)

By far most of the usages of class.semaphore or class.mutex in drivers
are to protect the class.devices list.  The only=B9 right thing to do
there is to keep using the class.{semaphore,mutex}.  The more elegant
variation of this would be David's class_for_each_instance() iterator
which would allow us to hide the locking details from the drivers.

-------
=B9)  Well, another correct thing to do would be to not take any locks or
mutexes in the driver core but instead let the drivers do the necessary
serialization between calls like class_device_add() and the likes and
list iterations.  But this would complicate the API because of the
additional locking requirements, and hence would invariably result in
buggy usages of the API.
-- =

Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--- ---=3D --=3D=3D=3D
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
