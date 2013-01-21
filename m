From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Mon, 21 Jan 2013 21:36:02 +0800
Message-ID: <50FD4442.9080600@intel.com>
References: <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/20/2013 02:46 AM, Alan Stern wrote:
> On Sat, 19 Jan 2013, Aaron Lu wrote:
>> Then we indeed have a problem. But I didn't find any such app in
>> Fedora's repo or by searching the internet.
>
> http://rpm.pbone.net/index.php3/stat/4/idpl/2392183/dir/redhat_5.x/com/cdp-0.33-10.i386.rpm.html

Now that with the RFC PATCH, the cd drive's runtime status will always
be active if there is disc inside, so we don't have this problem any
more. Tested on two systems, one with a ZP-drive and the other with a
normal one.

BTW, I can't get the above app run, as it requires an old ncurses lib.
And compiling it is not easy...

For an amusement, I wrote the following stupid simple app intended for
test:

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <linux/cdrom.h>

int main(void)
{
	int ret = 0;
	struct cdrom_msf msf = { 1, 0, 0, 2, 0, 0 };
	int fd;
	
	fd = open("/dev/sr0", O_RDONLY | O_NONBLOCK);
	if (fd == -1) {
		perror("open");
		return -1;
	}

	ret = ioctl(fd, CDROMPLAYMSF, &msf);
	if (ret) {
		perror("ioctl");
		goto out;
	}
out:
	close(fd);

	return ret;
}

Insert an audio disc, make sure no app is accessing it, run the above
app, then the app will exit and the led on the drive will be blinking
for roughly one minute, as the app has set, but I didn't hear any sound...

And the runtime status is of course active all the time, no matter if
there is app accessing it or not as expected.

Thanks,
Aaron
