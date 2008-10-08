From: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [PATCH 05/12] adt7470: Add documentation
Date: Wed, 8 Oct 2008 11:46:47 +0200
Message-ID: <20081008114647.5508b4ba@hyperion.delvare>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
	<20081007011849.12701.53492.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:22708 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYJHJrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 05:47:05 -0400
In-Reply-To: <20081007011849.12701.53492.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>

Hi Darrick,

On Mon, 06 Oct 2008 18:18:49 -0700, Darrick J. Wong wrote:
> 
> Add at least the bare minimum of documentation for this chip.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/adt7470 |   74 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 74 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/adt7470 b/Documentation/hwmon/adt7470
> new file mode 100644
> index 0000000..10f398b
> --- /dev/null
> +++ b/Documentation/hwmon/adt7470
> @@ -0,0 +1,74 @@
> +Kernel driver adt7470
> +======================
> +
> +Supported chips:
> +  * Analog Devices ADT7470
> +    Prefix: 'adt7470'
> +    Addresses scanned: I2C 0x2C, 0x2E, 0x2F
> +    Datasheet: Publicly available at the Analog Devices website
> +
> +Author: Darrick J. Wong
> +
> +Description
> +-----------
> +
> +This driver implements support for the Analog Devices ADT7470 chip family.

Family? The driver only supports one chip.

> +
> +The ADT7470 uses the 2-wire interface compatible with the SMBUS 2.0

SMBus

> +specification. Using an analog to digital converter it measures ten (10)
> +temperatures. It has four (4) 16-bit counters for measuring fan speed. There

up to ten external temperatures

> +are four (4) PWM outputs that can be used to control fan speed.
> +
> +A sophisticated control system for the PWM outputs is designed into the ADT7470
> +that allows fan speed to be adjusted automatically based on any of the three
> +temperature sensors. Each PWM output is individually adjustable and

ten temperature sensors

> +programmable. Once configured, the ADT7470 will adjust the PWM outputs in
> +response to the measured temperatures without further host intervention.  This
> +feature can also be disabled for manual control of the PWM's.
> +
> +Each of the measured inputs (temperature, fan speed) has corresponding high/low
> +limit values. The ADT7470 will signal an ALARM if any measured value exceeds
> +either limit.
> +
> +The ADT7470 DOES NOT sample all inputs continuously.  A single pin on the
> +ADT7470 is connected to a multitude of thermal diodes, but the chip must be
> +instructed explicitly to read the multitude of diodes.  If you want to use
> +automatic fan control mode, you must manually read any of the temperature
> +sensors or the fan control algorithm will not run.  The chip WILL NOT DO THIS
> +AUTOMATICALLY; this must be done from userspace.  This may be a bug in the chip
> +design, given that many other AD chips take care of this.  The driver will not

This is very weird. This pretty much voids the point of an automatic
fan control mode. If you have to read registers continuously for it to
work, you can as well control it completely in software.

> +read the registers more often than once every other second.  Further,

Actually every 5 seconds according to the driver code.

> +configuration data is only read once per minute.
> +
> +Special Features
> +----------------
> +
> +The ADT7470 have a 8-bit ADC and can therefore measure temperatures
> +with 1 degC resolution.

This "therefore" is incorrect. You can't deduce the physical resolution
from the ADC resolution, you need to additionally know the LSB weight
for that.

> +
> +The Analog Devices datasheet is very detailed and describes a procedure for
> +determining an optimal configuration for the automatic PWM control.
> +
> +Configuration Notes
> +-------------------
> +
> +Besides standard interfaces driver adds the following:
> +
> +* PWM Control
> +
> +* pwm#_auto_point1_pwm and temp#_auto_point1_temp and
> +* pwm#_auto_point2_pwm and temp#_auto_point2_temp -
> +
> +point1: Set the pwm speed at a lower temperature bound.
> +point2: Set the pwm speed at a higher temperature bound.
> +
> +The ADT7470 will scale the pwm between the lower and higher pwm speed when
> +the temperature is between the two temperature boundaries.  PWM values range
> +from 0 (off) to 255 (full speed).  Fan speed will be set to maximum when the
> +temperature sensor associated with the PWM control exceeds temp#_max.
> +
> +Notes
> +-----
> +
> +As stated above, the temperature inputs must be read periodically from
> +userspace in order for the automatic pwm algorithm to run.

Please send an updated patch.

Out of curiosity: isn't it possible to detect how many thermal sensors
are actually connected, and only create sysfs files for these? Creating
files for sensors which do not exist is rather confusing.

-- 
Jean Delvare
